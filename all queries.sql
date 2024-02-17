SELECT * FROM geminivschatgpt.benchmarks;

-- 1)What are the average scores for each capability on both the Gemini Ultra and GPT-4 models?
SELECT CapabilityName,AVG(ScoreGemini) AS 'Avg_of_Gemini', AVG(ScoreGPT4) AS 'Avg_of_GPT4'
FROM benchmarks t1
JOIN capabilities t2
ON t1.CapabilityID=t2.CapabilityID
GROUP BY CapabilityName;

-- 2)Which benchmarks does Gemini Ultra outperform GPT-4 in terms of scores?
SELECT DISTINCT(BenchmarkName), ScoreGemini,ScoreGPT4 FROM benchmarks
WHERE ScoreGemini>ScoreGPT4;

-- 3)What are the highest scores achieved by Gemini Ultra and GPT-4 for each benchmark in the Image capability?
SELECT BenchmarkName,MAX(ScoreGemini),MAX(ScoreGPT4)
FROM benchmarks t1
JOIN capabilities t2
ON t1.CapabilityID=t2.CapabilityID
WHERE CapabilityName='Image'
GROUP BY BenchmarkName;

-- 4)Calculate the percentage improvement of Gemini Ultra over GPT-4 for each benchmark?
SELECT BenchmarkName,ScoreGemini,ScoreGPT4,
((ScoreGemini-ScoreGPT4)/ScoreGemini)*100 AS 'Percentage_of_Improvement'
FROM benchmarks
ORDER BY Percentage_of_Improvement DESC;

-- 5)Retrieve the benchmarks where both models scored above the average for their respective models?
SELECT BenchmarkName FROM benchmarks
WHERE ScoreGemini > (SELECT AVG(ScoreGemini) FROM benchmarks) 
AND ScoreGPT4 > (SELECT AVG(ScoreGPT4) FROM benchmarks);

-- 6)Which benchmarks show that Gemini Ultra is expected to outperform GPT-4 based on the next score?
SELECT BenchmarkName,ScoreGemini;

-- 7)Classify benchmarks into performance categories based on score ranges?
SELECT BenchmarkName, 
CASE
	WHEN ScoreGemini >= 90.0 THEN "Excellent_Performance"
	WHEN ScoreGemini >= 80.0 THEN "Good_Performance"
	WHEN ScoreGemini >= 70.0 THEN "Average_Performance"
	WHEN ScoreGemini >= 60.0 THEN "Below_Average_Performance"
	ELSE "Poor_Performance"
END AS Performance_Of_Gemini,
CASE
	WHEN ScoreGPT4 >= 90.0 THEN "Excellent_Performance"
	WHEN ScoreGPT4 >= 80.0 THEN "Good_Performance"
	WHEN ScoreGPT4 >= 70.0 THEN "Average_Performance"
	WHEN ScoreGPT4 >= 60.0 THEN "Below_Average_Performance"
	ELSE "Poor_Performance"
END AS Performance_Of_GPT4 
FROM benchmarks
WHERE ScoreGPT4 IS NOT NULL;

-- 8) Retrieve the rankings for each capability based on Gemini Ultra scores?
SELECT BenchmarkName,CapabilityName,ScoreGemini,
DENSE_RANK() OVER(PARTITION BY CapabilityName ORDER BY ScoreGemini DESC) AS 'Ranking'
FROM benchmarks t1
JOIN capabilities t2
ON t1.CapabilityID=t2.CapabilityID;

-- 9)Convert the Capability and Benchmark names to uppercase?
SELECT UPPER(BenchmarkName) AS 'BenchmarkName',UPPER(CapabilityName) AS 'CapabilityName'
FROM benchmarks t1
JOIN capabilities t2
ON t1.CapabilityID=t2.CapabilityID;

-- 10) Can you provide the benchmarks along with their descriptions in a concatenated format? 
SELECT CONCAT(BenchmarkName,':','[',Description,']' ) AS 'Title'
FROM benchmarks;














