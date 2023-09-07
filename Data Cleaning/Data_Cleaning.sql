-- Cleaning Data
SELECT *
FROM PortofolioDatabase.dbo.NashvilleHousing

--------------------------------------------------

-- Standarize Date Format
SELECT SaleDate, CONVERT(date, SaleDate)
FROM PortofolioDatabase.dbo.NashvilleHousing

SELECT SaleDateConverted, CONVERT(date, SaleDate)
FROM PortofolioDatabase.dbo.NashvilleHousing


UPDATE NashvilleHousing
Set SaleDate = CONVERT(date, SaleDate)

ALTER TABLE NashvilleHousing
ADD SaleDateConverted Date;

UPDATE NashvilleHousing
Set SaleDateConverted = CONVERT(date, SaleDate)

--------------------------------------------------

-- Populate Property Address data

SELECT *
FROM PortofolioDatabase.dbo.NashvilleHousing
--WHERE PropertyAddress IS NULL
ORDER BY ParcelID


SELECT *
FROM PortofolioDatabase.dbo.NashvilleHousing a
JOIN PortofolioDatabase.dbo.NashvilleHousing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID] <> b.[UniqueID]

--------------------------------------------------

