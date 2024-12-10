select *
from PortfolioProjects.dbo.[NashvilleHousing]


--Standardize Date Format

select SaleDateConverted,convert(date,saledate)
from PortfolioProjects.dbo.[NashvilleHousing]

Update [NashvilleHousing]
set Saledate=convert(date,saledate)

Alter table NashvilleHousing
add SaleDateConverted Date;

Update [NashvilleHousing]
set SaleDateConverted=convert(date,saledate)


--Populate Propert Address Data

select *
from PortfolioProjects.dbo.[NashvilleHousing]
--where propertyaddress is null
order by ParcelID


select a.parcelid, a.propertyaddress,b.parcelid,b.propertyaddress,isnull(a.propertyaddress,b.propertyaddress)
from PortfolioProjects.dbo.[NashvilleHousing] a
join PortfolioProjects.dbo.[NashvilleHousing] b
on a.parcelid = b.parcelid
and a.UniqueID <> b.UniqueID
where a.propertyaddress is null


Update a
set propertyaddress = isnull(a.propertyaddress,b.propertyaddress)
from PortfolioProjects.dbo.[NashvilleHousing] a
join PortfolioProjects.dbo.[NashvilleHousing] b
on a.parcelid = b.parcelid
and a.UniqueID <> b.UniqueID
where a.propertyaddress is null


--Breaking out Propert Address into Individual Columns ( address,City,State)


select propertyaddress
from PortfolioProjects.dbo.[NashvilleHousing]
--where propertyaddress is null
--order by ParcelID


SELECT
SUBSTRING(PropertyAddress,1,CHARINDEX(',',propertyaddress) -1) as Address
,SUBSTRING(PropertyAddress,CHARINDEX(',',propertyaddress) +1, LEN(propertyaddress)) as address

from PortfolioProjects.dbo.[NashvilleHousing]

Alter table NashvilleHousing
add PropertSplitAddress NVARCHAR(255);

Update [NashvilleHousing]
set PropertSplitAddress=SUBSTRING(PropertyAddress,1,CHARINDEX(',',propertyaddress) -1)

Alter table NashvilleHousing
add PropertSplitCity NVARCHAR(255);

Update [NashvilleHousing]
set PropertSplitCity=SUBSTRING(PropertyAddress,CHARINDEX(',',propertyaddress) +1, LEN(propertyaddress))


select *
from PortfolioProjects.dbo.NashvilleHousing



select OwnerAddress
from PortfolioProjects.dbo.NashvilleHousing

SELECT
PARSENAME(replace(owneraddress,',','.'),3),
PARSENAME(replace(owneraddress,',','.'),2),
PARSENAME(replace(owneraddress,',','.'),1)
from PortfolioProjects.dbo.NashvilleHousing


Alter table NashvilleHousing
add OwnerSplitAddress NVARCHAR(255);

Update [NashvilleHousing]
set OwnerSplitAddress=PARSENAME(replace(owneraddress,',','.'),3)

Alter table NashvilleHousing
add OwnerSplitCity NVARCHAR(255);

Update [NashvilleHousing]
set OwnerSplitCity=PARSENAME(replace(owneraddress,',','.'),2)

Alter table NashvilleHousing
add OwnerSplitState NVARCHAR(255);

Update [NashvilleHousing]
set OwnerSplitState=PARSENAME(replace(owneraddress,',','.'),1)



--Change Y and N to Yes and No in " Sold as vacant" field

select distinct(Soldasvacant),count(soldasvacant)
from PortfolioProjects.dbo.NashvilleHousing
group by soldasvacant
order by 2


SELECT Soldasvacant,
case when soldasvacant = 'Y' then 'Yes'
     when soldasvacant = 'N' then 'No'
     else Soldasvacant
     END
from PortfolioProjects.dbo.NashvilleHousing


Update NashvilleHousing
SET soldasvacant = case when soldasvacant = 'Y' then 'Yes'
     when soldasvacant = 'N' then 'No'
     else Soldasvacant
     END


--Remove Duplicates

With RowNumCTE as(
select *,
ROW_NUMBER() over (
    PARTITION BY parcelid,propertyaddress,saleprice,saledate,legalreference 
    order by uniqueID
) row_num
from PortfolioProjects.dbo.NashvilleHousing
--order by parcelid
)

Delete
from RowNumCTE
where row_num > 1
--order by parcelid



--Delete Unused Columns

select *
from PortfolioProjects.dbo.NashvilleHousing


ALTER TABLE PortfolioProjects.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress


ALTER TABLE PortfolioProjects.dbo.NashvilleHousing
DROP COLUMN SaleDate
