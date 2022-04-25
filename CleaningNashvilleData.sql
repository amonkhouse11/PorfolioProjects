--Cleaning Data in SQL Queries
SELECT *
FROM Projectportfolio.dbo.NashvilleData;

-- Standardzie Date Format
SELECT SaleDateConverted
FROM Projectportfolio.dbo.NashvilleData;

ALTER TABLE NashvilleData
ADD SaleDateConverted Date;

UPDATE NashvilleData
SET SaleDateConverted= CONVERT(Date, SaleDate);

--Populate Property Address Data

SELECT *
FROM Projectportfolio.dbo.NashvilleData
WHERE Propertyaddress IS NULL;


SELECT A.ParcelID, A.PropertyAddress, B.ParcelID, B.PropertyAddress, ISNULL(A.PropertyAddress, B.PropertyAddress)
FROM Projectportfolio.dbo.NashvilleData A
JOIN Projectportfolio.dbo.NashvilleData B
	ON A.ParcelID= B.ParcelID
	AND A.[UNIQUEID] <> B.[UNIQUEID]
WHERE A.PropertyAddress IS NULL;

UPDATE A
SET Propertyaddress = ISNULL(A.PropertyAddress, B.PropertyAddress)
FROM Projectportfolio.dbo.NashvilleData A
JOIN Projectportfolio.dbo.NashvilleData B
	ON A.ParcelID= B.ParcelID
	AND A.[UNIQUEID] <> B.[UNIQUEID]
WHERE A.PropertyAddress IS NULL;

--Breaking out Address into individual columns (Address, City, State)

SELECT PropertyAddress
FROM Projectportfolio.dbo.NashvilleData;

SELECT 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) AS Address,
	SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+ 1, LEN(PropertyAddress)) AS Address
FROM Projectportfolio.dbo.NashvilleData;


ALTER TABLE NashvilleData
ADD PropertySplitAddress NVARCHAR(255);

UPDATE NashvilleData
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1);


ALTER TABLE NashvilleData
ADD PropertySplitCity NVARCHAR(255);

UPDATE NashvilleData
SET PropertySplitCity  = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+ 1, LEN(PropertyAddress));


SELECT OwnerAddress
FROM Projectportfolio.dbo.NashvilleData;

SELECT
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3),
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2),
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)
FROM Projectportfolio.dbo.NashvilleData;

ALTER TABLE NashvilleData
ADD OwnerSplitAddress NVARCHAR(255);

UPDATE NashvilleData
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3);

ALTER TABLE NashvilleData
ADD OwnerSplitCity NVARCHAR(255);

UPDATE NashvilleData
SET OwnerSplitCity  = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2);

ALTER TABLE NashvilleData
ADD OwnerSplitState NVARCHAR(255);

UPDATE NashvilleData
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1);

--Change Y & N to YES & NO in "Sold as vacant" field

SELECT SoldAsVacant,
 CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	WHEN SoldAsVacant = 'N' THEN 'No'
	ELSE SoldAsVacant
	END
FROM Projectportfolio.dbo.NashvilleData;

UPDATE NashvilleData
SET SoldASVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	WHEN SoldAsVacant = 'N' THEN 'No'
	ELSE SoldAsVacant
	END;

-- Remove Duplicates
WITH RowNumCTE AS (
SELECT *, 
	ROW_NUMBER() OVER(
	PARTITION BY PARCELID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY 
					UniqueID
					) Row_num
FROM Projectportfolio.dbo.NashvilleData
)
DELETE 
FROM RowNumCTE
WHERE Row_num > 1;

-- Delete Unused Columns

ALTER TABLE Projectportfolio.dbo.NashvilleData
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate;

ALTER TABLE Projectportfolio.dbo.NashvilleData
DROP COLUMN SaleDate;



