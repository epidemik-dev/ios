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
	public static var QUESTION_DICT =
		[1: "I have a runny nose",
		 2: "I have a fever",
		 3:"My eyes are watering",
		 4:"I am sneezing a lot",
		 5:"I have a headache",
		 6: "I have chills",
		 7: "I am fatigued",
		 8: "I am congested",
		 9: "I have vomited today",
		 10: "I have diarrhea",
		 11: "I am nauseous",
		 12: "I have cramps",
		 13: "I have swelling",
		 14: "I am feeling very itchy",
		 15: "I have a rash",
		 16: "I have blisters",
		 17: "I have a sore throat",
		 18: "I am aching all over",
		 19: "I have a bull's eye rash",
		 20: "I have a cough",
		 21: "I am sweating at night",
		 22: "I am not hungry",
		 23: "My eyes are itchy",
		 24: "My eyes are red",
		 25: "I have discharge",
		 26: "My eyes are swelling",
		 27: "I have mouth sores"]

	public static var COMMON_COLD_QUESTIONS = [1, 2, 3, 4, 5]
	public static var FLU_QUESTIONS = [6, 2, 7, 8, 4]
	public static var GAST_QUESTIONS = [9, 10, 11, 12, 2]
	public static var STAPH_QUESTIONS = [13, 14, 15, 2, 16]
	public static var STREP_QUESTIONS = [17, 13, 2, 18, 5]
	public static var LYME_QUESTIONS = [19, 2, 5, 7, 18]
	public static var TEB_QUESTIONS = [20, 21, 6, 7, 22]
	public static var PINK_QUESTIONS = [23, 3, 24, 25, 26]
	public static var HAND_QUESTIONS = [15, 16, 20, 5, 27]

	public static func getDiseaseQuestions(diseaseName: String) -> Array<Int> {
		if(diseaseName == "Influenza (Flu)") {
			return FLU_QUESTIONS
		} else if(diseaseName == "Gastroenteritis (Stomach Flu)") {
			return GAST_QUESTIONS
		} else if(diseaseName == "Staph Infection") {
			return STAPH_QUESTIONS
		} else if(diseaseName == "Strep Throat") {
			return STREP_QUESTIONS
		} else if(diseaseName == "Common Cold") {
			return COMMON_COLD_QUESTIONS
		} else if(diseaseName == "Lyme Disease") {
			return LYME_QUESTIONS
		} else if(diseaseName == "Tuberculosis") {
			return TEB_QUESTIONS
		} else if(diseaseName == "Pink Eye") {
			return PINK_QUESTIONS
		} else if(diseaseName == "Hand Foot and Mouth") {
			return HAND_QUESTIONS
		} else {
			return COMMON_COLD_QUESTIONS
		}
	}
	
	public static func getBodyPartQuestions(bodyPart: String) -> Array<Int> {
		if(bodyPart == "head") {
			return [5, 1, 2, 3]
		} else {
			return [7, 8, 9]
		}
	}
}
