import random

# Define the lists
fullbody = [
    'Power cleans', 
    'Power snatches', 
    'Hang cleans', 
    'Hang snatches', 
    'Box jump', 
    'Lunge jumps', 
    'Kettlebell snatch', 
    'Sandbag shouldering', 
    'Sandbag shoulder to carry', 
    'Clean/front squat/press', 
    'Deadlift/clean/front squat/press'
]

lowbody = [
    'Squat', 
    'Front squat', 
    'Lunge', 
    'Step-up', 
    'Straight leg deadlift', 
    'Good mornings', 
    'Kettlebell swings', 
    'Hungarian core blaster', 
    'Jump squats', 
    'Side lunge'
]

upperbody = [
    'Bench Press', 
    'Press', 
    'Dumbbell presses (flat, standing)', 
    'Close grip bench', 
    'Chin –ups', 
    'Pull-ups', 
    'Rope chins', 
    'Hand/hand sled pulls with rope', 
    'Dumbbell rows', 
    '2" rows', 
    'Push-ups', 
    'Incline push-ups', 
    'Push press', 
    'Dumbbell push press', 
    'Single arm dumbbell bench press', 
    'Single arm press'
]

core = [
    'Sit-ups', 
    'Weighted Sit-ups', 
    'Lying leg raises', 
    'Planks (front and side)', 
    'Hanging leg raises', 
    'Abdominal wheel', 
    'Dumbbell side bends', 
    'Russian twist', 
    'Pikes', 
    'Alternate toe touch and plank', 
    'Side plank reach throughs', 
    'Plank push/pull'
]

conditioning = [
    'Jump rope', 
    'Bear crawl', 
    'Burpees',
    'Step machine',
    'Weighted carry',
]

# Select a random exercise from each list
random_fullbody = random.choice(fullbody)
random_upperbody = random.choice(upperbody)
random_conditioning = random.choice(conditioning)
random_lowbody = random.choice(lowbody)
random_core = random.choice(core)

# Print the randomly selected exercises
print()
print("Full Body Exercise")
print("Upper Body Exercise")
print("Conditioning Exercise")
print("Lower Body Exercise")
print("Core Exercise")

print()
print("1)", random_fullbody, "(Full)")
print("3)", random_upperbody, "(Upper)")
print("2)", random_conditioning, "(Conditioning)")
print("2)", random_lowbody, "(Low)") 
print("4)", random_core, "(Core)")

print()