# CheckerBoardCollection

![[Swift]](https://img.shields.io/badge/Swift-3.0-F16D39.svg)
![CocoaPods](https://img.shields.io/cocoapods/v/CheckerBoardCollection.svg)
[![Build Status](https://travis-ci.org/Yaro812/CheckerBoardCollection.svg?branch=master)](https://travis-ci.org/Yaro812/CheckerBoardCollection)

## Synopsis

UICollectionView vertical flow layout that lays cells in a checker board style
Horizontal layout is not implemented

## Installation

Using Cocoapods: 
`pod 'CheckerBoardCollection'`

## Usage

To use automatic cell size calculation set property _columns_ to some value > 0
`layout.columns = 3`

## Problems
There is a bug in rows calculation when Header of Footer height is more than 0
