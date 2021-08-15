# Courtify Smart Contract Repo

This repository contains all the relevant required smart contracts for the Cortify system to work.

## Badges

Version & Tag:

![GitHub tag (latest by date)](https://img.shields.io/github/v/tag/Courtify/courtify-sc)

Issue & PR:

![GitHub issues](https://img.shields.io/github/issues/Courtify/courtify-sc)
![GitHub pull requests](https://img.shields.io/github/issues-pr/Courtify/courtify-sc)

CI & Code Coverage:

[![Node.js CI](https://github.com/Courtify/courtify-sc/actions/workflows/node.js.yml/badge.svg)](https://github.com/Courtify/courtify-sc/actions/workflows/node.js.yml)
[![Coverage Status](https://coveralls.io/repos/github/Courtify/courtify-sc/badge.svg?branch=main)](https://coveralls.io/github/Courtify/courtify-sc?branch=main)

Metrics & Activity:

![GitHub language count](https://img.shields.io/github/languages/count/Courtify/courtify-sc)
![GitHub commit activity](https://img.shields.io/github/commit-activity/y/Courtify/courtify-sc)
![GitHub last commit](https://img.shields.io/github/last-commit/Courtify/courtify-sc)

## Description

Courtify smart contracts have mainly two parts. One is the access contract, which defines granular access to the Courtify main smart contract. And the courtify smart contract which takes in cases, and provides a decentralized and public view of our courts and cases (where deemed necessary).

## UML Diagram

![UML Diagram](UML.svg)

## Deployment

- [Polygon Mumbai Testnet](https://mumbai.polygonscan.com/address/0x3180e17578ECca94976005904574E4Daa79D6935#code) (Verified)

## Assumptions

- Chief Justice won't be a bad character. (Though an easy way is to have a multisig as the Chief Justice Wallet.)

## Improvements

- Gas Optimization can be done through saving most values as `uint256` instead of `string` and parsing the same in Frontend.
