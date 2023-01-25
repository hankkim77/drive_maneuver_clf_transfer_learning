driving_maneuver_master

Detect and Classify aggressive driving maneuver using GNSS/IMU/CAN Bus data


(A,B) Common Procedure for preparing dataset for Deep Learning

0. Set requirements.txt environment
1. Prepare vehicle sensor data including 
[TimeStamp, AccelX, AccelY, AccelZ, GyroX, GyroY, GyroZ, Heading, Speed, SAS_Angle, lateral_offset] features
1-1. Function to calculate lateral offset(displacement) from 'B.Candidate_extraction/matlab/find_lc_candidate.m' 
2. Run 'B.Candidate_extraction/matlab/candidate_extraction.m' 	(input data_path = '../../Data/data_10Hz.csv')	##extract Lane Change candidate 
3. Run 'B.Candidate_extraction/candidate_to_df.ipynb'	##Add Lane Change candidate as feature
4. Run 'A.Data_processing/0-0.rule_based_labeling.ipynb'	##Make Rule based label if you don't have maneuver label
5. Run 'A.Data_processing/0-1.windowing.ipynb'  	##window slicing for model_based learning

(C) Procedure for Model-based Learning

1. Run 'C-1.HAR_model/..' notebooks for model based-learning
1-1. model parameter saved in 'saved_model' folder
1-2. inference(prediction) for test_data saved in 'pred_results' folder
2. 'C-2.Ensemble_Learning/Ensemble_model.ipynb'	##ensemble method to develop test score

(D) Procedure for Transfer Learning using UEA multivariate Time Series Classification datasets 

1. Run 'D.Multivariate-ts_transfer/transfer_learning~.ipynb'	## pretrain/ transfer learning 
2. Run 'Compare_original_transfer.ipynb', 'Confusion_matrix.ipynb'	## get transfer learning results
3. Run 'Compare_signal_shape.ipynb', 'imbalance_ratio.ipynb', 'similarity_measures.ipynb'	## Some statistics maybe related to transfer learning results
