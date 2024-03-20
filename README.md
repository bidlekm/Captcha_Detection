# Pipeline for Identifying 3-Digit Numbers on Captcha Images

## Aim
The aim of this project was to design and build a pipeline for an image analysis task, specifically to identify 3-digit numbers on captcha images. The goal was to achieve at least 50% accuracy in identifying the digits.

## Main Properties of Images Affecting Solution
- Captcha images contain digits 3, 4, and 5 with possible repetitions and in any order.
- Images exhibit Gaussian noise, a striped pattern, overlapping digits, and flat lines.
- Digits vary in size, rotation, and position within the image.

## Challenges Envisioned
- Denoising the image.
- Segmenting and classifying overlapping digits efficiently.
- Handling variations in size, rotation, and position of digits.

## Initial Ideas to Tackle Challenges
- Utilize total variation denoising, thresholding, and morphology for noise removal.
- Implement template matching for digit classification and segmentation.

## Method

### Noise Removal in Fourier Domain
- Striped patterns in images identified in Fourier domain.
- A mask created to remove stripes.

### Gaussian Noise Removal
- Total variation energy minimization initially attempted but switched to Wiener filtering for efficiency.

### Thresholding
- Histogram equalization performed before thresholding.
- Manual selection of thresholding value based on histograms.

### Morphological Transformation
- Erosion and dilation used to remove scattered lines around digits.

### Area Filtering
- Area filter applied to remove small unconnected regions.

### Area Segmentation
- Image cropped to segment three digits, each roughly one-third of the image.

### Template Matching Using Cross Correlation
- Digits rescaled and rotated for template creation.
- Normalized cross-correlation used for matching.
- Digit with the highest correlation chosen as classification.

## Implementation
- Preprocessing steps performed including noise removal, thresholding, and morphology.
- Segmentation and template matching implemented for digit identification.

## Results
- Classification results on the provided training set:
  - Accuracy: 62.75%
  - Elapsed Time: 126.55 sec
  - Mean Time per Image: 0.103 sec

## Discussion
### Possible Improvement Areas
- Fine-tuning variables and measures for better optimization.
- Improving digit segmentation for rotated numbers.
- Introducing new templates for better matching.

### Alternative Solutions
- Experimentation with supervised learning models like k-NN classifier.

