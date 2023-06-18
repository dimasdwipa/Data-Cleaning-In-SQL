/*

Cleaning Data in SQL Queries

*/

Select *
From PortfolioProject..NashvilleHousing

-- Standardize Data Format

Select SaleDateConverted, CONVERT(Date,SaleDate)
From PortfolioProject..NashvilleHousing

Update NashvilleHousing
SET SaleDate = CONVERT(Date,SaleDate)

ALTER TABLE NashvilleHousing
add SaleDateConverted Date;

Update NashvilleHousing
SET SaleDateConverted = CONVERT(Date,SaleDate)

----------------------------------------------------------------------------------------------------------------------------

-- Populate Property Address Data

Select *
From PortfolioProject..NashvilleHousing
--Where PropertyAddress is null
order by ParcelID



Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortfolioProject..NashvilleHousing as a
JOIN PortfolioProject..NashvilleHousing as b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null


Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortfolioProject..NashvilleHousing as a
JOIN PortfolioProject..NashvilleHousing as b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null



----------------------------------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, City, State)

Select PropertyAddress
From PortfolioProject..NashvilleHousing
--Where PropertyAddress is null
--order by ParcelID

SELECT 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress) -1 ) as Address
 , SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) + 1 , LEN(PropertyAddress)) as Address
From PortfolioProject..NashvilleHousing


ALTER TABLE NashvilleHousing
add PropertySplitAddress Nvarchar(255);

Update NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress) -1 )

ALTER TABLE NashvilleHousing
add PropertySplitCity Nvarchar(255);

Update NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) + 1 , LEN(PropertyAddress))


Select *
From PortfolioProject..NashvilleHousing




Select OwnerAddress
From PortfolioProject..NashvilleHousing


Select 
PARSENAME(Replace(OwnerAddress, ',', '.'),3)
,PARSENAME(Replace(OwnerAddress, ',', '.'),2)
,PARSENAME(Replace(OwnerAddress, ',', '.'),1)
From PortfolioProject..NashvilleHousing


ALTER TABLE NashvilleHousing
add OwnerSplitAddress Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitAddress = PARSENAME(Replace(OwnerAddress, ',', '.'),3)

ALTER TABLE NashvilleHousing
add OwnerSplitCity Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitCity = PARSENAME(Replace(OwnerAddress, ',', '.'),2)

ALTER TABLE NashvilleHousing
add OwnerSplitState Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitState = PARSENAME(Replace(OwnerAddress, ',', '.'),1)

Select *
From PortfolioProject..NashvilleHousing


----------------------------------------------------------------------------------------------------------------------------

-- Change Y and N to Yes and No in "Solid as Vacant" Field

Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From PortfolioProject..NashvilleHousing
Group by SoldAsVacant
order by 2



Select SoldAsVacant
, Case When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' Then 'No'
	   Else SoldAsVacant
	   End
From PortfolioProject..NashvilleHousing


Update NashvilleHousing
SET SoldAsVacant = Case When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' Then 'No'
	   Else SoldAsVacant
	   End

Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From PortfolioProject..NashvilleHousing
Group by SoldAsVacant
order by 2



----------------------------------------------------------------------------------------------------------------------------

--Remove Duplicates

WITH RowNumCTE as (
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num
					
From PortfolioProject..NashvilleHousing
--order by ParcelID 
)
Select *
From RowNumCTE
Where row_num > 1
Order BY PropertyAddress


Select *
From PortfolioProject..NashvilleHousing






----------------------------------------------------------------------------------------------------------------------------

-- Delete Unused Columns


Select *
From PortfolioProject..NashvilleHousing

ALTER TABLE PortfolioProject..NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE PortfolioProject..NashvilleHousing
DROP COLUMN SaleDate




