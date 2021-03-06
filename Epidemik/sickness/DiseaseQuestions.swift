//
//  DiseaseQuestions.swift
//  Epidemik
//
//  Created by Ryan Bradford on 3/24/18.
//  Copyright © 2018 RBradford Studios. All rights reserved.
//

import Foundation

public class DISEASE_QUESTIONS {
	
	// The map of all symptoms that a disease can have
	// Needs to be sorted later
	public static var QUESTION_DICT: [Int: String] =
		[:]
	// THe map that stores about which diseases will ask which symptoms
	public static var DISEASE_QUESTION_MAP: [String: Array<Int>] = [:]
	// The map which stores about which body parts will ask which symptoms
	public static var BODY_PART_QUESTION_MAP: [String: Array<Int>] = [:]
	//All the diseses that we display
	public static var diseases: Array<String> = []
	//Returns what given symptoms match with the given disease
	public static func getMatchingSymptoms(diseaseName: String, symptoms: Array<Int>) -> Array<Int> {
		var toReturn = Array<Int>()
		let diseaseName2 = diseaseName.replacingOccurrences(of: "-", with: " ")
		let diseaseSymptoms = DISEASE_QUESTION_MAP[diseaseName2]
		for symptom in symptoms {
			if(diseaseSymptoms!.contains(symptom)) {
				toReturn.append(symptom)
			}
		}
		return toReturn
	}
}
