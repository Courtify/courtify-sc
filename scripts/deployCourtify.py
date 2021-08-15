from brownie import *

import time
import json
import sys
import csv
import math

def main():
    loadConfig()

    balanceBefore = acct.balance()
    choice()
    balanceAfter = acct.balance()

    print("=============================================================")
    print("Balance Before:  ", balanceBefore)
    print("Balance After:   ", balanceAfter)
    print("Gas Used:        ", balanceBefore - balanceAfter)
    print("=============================================================")

# =========================================================================================================================================
def loadConfig():
    global values, acct, thisNetwork
    thisNetwork = network.show_active()

    if thisNetwork == "development":
        acct = accounts[0]
        configFile = open('./scripts/values/development.json')
    elif thisNetwork == "polygon-testnet":
        acct = accounts.load("chrome")
        configFile = open('./scripts/values/testnet.json')
    elif thisNetwork == "polygon-mainnet":
        acct = accounts.load("chrome")
        configFile = open('./scripts/values/mainnet.json')
    else:
        raise Exception("Network not supported.")

    # Load deployment parameters and contracts addresses
    values = json.load(configFile)

# =========================================================================================================================================
def choice():
    repeat = True
    while(repeat):
        print("\nOptions:")
        print("1 for Deploy Courtify.")
        print("2 for Transfer Chief Justice.")
        print("3 for Add a new Court.")
        print("4 for Remove a new Court.")
        print("5 for Add a new Advocate.")
        print("6 for Remove a new Advocate.")
        print("7 for Create a new case.")
        print("8 for Add an evidence.")
        print("9 for View all Courts.")
        print("10 for View all Advocates.")
        print("11 for View Case Detail.")
        print("12 for View Evidence Array.")
        print("13 for View Last Case ID.")
        print("14 for View Total Petitoner.")
        print("15 to exit.")
        selection = int(input("Enter the choice: "))
        if(selection == 1):
            deployCourtify()
        elif(selection == 2):
            transferChiefJustice()
        elif(selection == 3):
            addCourt()
        elif(selection == 4):
            removeCourt()
        elif(selection == 5):
            addAdvocate()
        elif(selection == 6):
            removeAdvocate()
        elif(selection == 7):
            createCase()
        elif(selection == 8):
            addEvidence()
        elif(selection == 9):
            viewCourts()
        elif(selection == 10):
            viewAdvocate()
        elif(selection == 11):
            viewCase()
        elif(selection == 12):
            viewEvidence()
        elif(selection == 13):
            viewLastCaseID()
        elif(selection == 14):
            viewTotalPetitoner()
        elif(selection == 15):
            repeat = False
        else:
            print("\nSmarter people have written this, enter valid selection ;)\n")

# =========================================================================================================================================
def deployCourtify():
    chiefJustice = values['chiefJustice']

    print("\n=============================================================")
    print("Deployment Parameters for Courtify")
    print("=============================================================")
    print("Chief Justice:       ", chiefJustice)
    print("=============================================================")

    courtify = acct.deploy(Courtify, chiefJustice)

    print("\Courtify Deployed.")

    values['courtify'] = str(courtify)
    writeToJSON()

# =========================================================================================================================================
def transferChiefJustice():
    courtify = Contract.from_abi("Courtify", address=values['courtify'], abi=Courtify.abi, owner=acct)
    print("\nTransferring Chief Justice of ...\n")
    courtify.transferChiefJustice(values['chiefJustice'])
    print("Updated Chief Justice as", values['chiefJustice'], " of Courtify...\n")

# =========================================================================================================================================
def addCourt():
    courtify = Contract.from_abi("Courtify", address=values['courtify'], abi=Courtify.abi, owner=acct)
    print("\nAdding a new Court in Courtify...\n")
    courtify.addCourt(values['court'])
    print("Added the court", values['court'], " in Courtify...\n")

# =========================================================================================================================================
def removeCourt():
    courtify = Contract.from_abi("Courtify", address=values['courtify'], abi=Courtify.abi, owner=acct)
    print("\nRemoving a new Court in Courtify...\n")
    courtify.removeCourt(values['court'])
    print("Removed the court", values['court'], " in Courtify...\n")

# =========================================================================================================================================
def addAdvocate():
    courtify = Contract.from_abi("Courtify", address=values['courtify'], abi=Courtify.abi, owner=acct)
    print("\nAdding a new Advocate in Courtify...\n")
    courtify.addAdvocate(values['advocate'])
    print("Added the Advocate", values['advocate'], " in Courtify...\n")

# =========================================================================================================================================
def removeAdvocate():
    courtify = Contract.from_abi("Courtify", address=values['courtify'], abi=Courtify.abi, owner=acct)
    print("\nRemoving a new Advocate in Courtify...\n")
    courtify.removeAdvocate(values['advocate'])
    print("Removed the Advocate", values['advocate'], " in Courtify...\n")

# =========================================================================================================================================
def readIndex(reason):
    print("\nIf you want to",reason,"the first index, i.e. Index = 1 in JSON, enter 1.")
    index = int(input("Enter the Tier ID (Based on JSON File): "))
    return index

# =========================================================================================================================================
def createCase():
    courtify = Contract.from_abi("Courtify", address=values['courtify'], abi=Courtify.abi, owner=acct)
    print("\nCreating a new case in Courtify...")
    index = readIndex("create the case in")
    case = values['cases'][index]
    timestamp = case['timestamp']
    state = case['state']
    district = case['district']
    court = case['court']
    petitonerID = case['petitonerID']
    name = case['name']
    caseType = case['caseType']

    print("\n=============================================================")
    print("Parameters for Case Creation")
    print("=============================================================")
    print("Timestamp:       ", timestamp)
    print("State:           ", state)
    print("District:        ", district)
    print("Court:           ", court)
    print("Petitoner ID:    ", petitonerID)
    print("Petitoner Name:  ", name)
    print("Case Type:       ", caseType)
    print("=============================================================")

    courtify.createNewCase(timestamp, state, district, court, petitonerID, name, caseType)
    print("New Case Created in Courtify...\n")

# =========================================================================================================================================
def addEvidence():
    courtify = Contract.from_abi("Courtify", address=values['courtify'], abi=Courtify.abi, owner=acct)
    print("\nAdding a new evidence in Courtify...")
    caseID = int("Enter the Case ID: ")
    evidence = values['evidence']

    print("\n=============================================================")
    print("Parameters for Evidence Addition")
    print("=============================================================")
    print("Evidence:        ", evidence)
    print("=============================================================")

    courtify.uploadEvidence(caseID, evidence)
    print("Added Evidence to Case", caseID, "in Courtify...\n")

# =========================================================================================================================================
def viewCourts():
    courtify = Contract.from_abi("Courtify", address=values['courtify'], abi=Courtify.abi, owner=acct)
    courts = courtify.getCourts()
    print("Courts:", courts)

# =========================================================================================================================================
def viewAdvocate():
    courtify = Contract.from_abi("Courtify", address=values['courtify'], abi=Courtify.abi, owner=acct)
    advocates = courtify.getAdvocates()
    print("Advocates:", advocates)

# =========================================================================================================================================
def viewCase():
    courtify = Contract.from_abi("Courtify", address=values['courtify'], abi=Courtify.abi, owner=acct)
    caseID = int("Enter the Case ID: ")
    case = courtify.getCase()
    print("Case Details of CaseID", caseID, ":", case)

# =========================================================================================================================================
def viewEvidence():
    courtify = Contract.from_abi("Courtify", address=values['courtify'], abi=Courtify.abi, owner=acct)
    caseID = int("Enter the Case ID: ")
    evidence = courtify.getEvidence()
    print("Evidence of CaseID", caseID, ":", evidence)

# =========================================================================================================================================
def viewLastCaseID():
    courtify = Contract.from_abi("Courtify", address=values['courtify'], abi=Courtify.abi, owner=acct)
    lastCaseID = courtify.lastCaseID()
    print("Last Case ID: ", lastCaseID)

# =========================================================================================================================================
def viewTotalPetitoner():
    courtify = Contract.from_abi("Courtify", address=values['courtify'], abi=Courtify.abi, owner=acct)
    totalPetitoner = courtify.totalPetitoner()
    print("Total Petitoner:", totalPetitoner)

# =========================================================================================================================================
def writeToJSON():
    if thisNetwork == "development":
        fileHandle = open('./scripts/values/development.json', "w")
    elif thisNetwork == "polygon-testnet":
        fileHandle = open('./scripts/values/testnet.json', "w")
    elif thisNetwork == "polygon-mainnet":
        fileHandle = open('./scripts/values/mainnet.json', "w")
    json.dump(values, fileHandle, indent=4)
