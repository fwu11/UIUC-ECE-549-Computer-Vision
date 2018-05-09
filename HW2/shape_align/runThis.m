%% ECE549 HW2
% Question 2 Shape alignment
close all
clear all

align_shape(imread('object2.png')>0,imread('object2t.png')>0);
align_shape(imread('object2.png')>0,imread('object1.png')>0);
align_shape(imread('object2.png')>0,imread('object3.png')>0);