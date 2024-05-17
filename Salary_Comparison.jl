using Plots, FileIO
using Statistics
using Random


# Load the data


number_of_employees = [453, 672, 946]
tot_num = sum(number_of_employees)
premaster = number_of_employees[1] ./ tot_num
intermediate = number_of_employees[2] ./ tot_num
candidate = number_of_employees[3] ./ tot_num
base_rate = 1814
variable_rate = 2333
tot_employees = base_rate + variable_rate


begin
# Define the coefficient matrix
A = [2.0/5.5  0       0.0;
    2.5/5.5  4.5/5.5   0.0;
    1.0/5.5  1.0/5.5 1.0]

# Define the constants vector (converted from percentages to decimal)
b = [21.9/100; 32.4/100; 45.7/100] .* tot_employees

# Solve the system of equations
x = inv(A) * b

# Print the solution
println("Solution: x = $(x[1]), y = $(x[2]), z = $(x[3])")
end


begin
    # # Function to generate a gradient of colors
    # function generate_gradient(start_color, end_color, num_colors)
    #     cgrad([start_color, end_color], num_colors)
    # end

    # # Generate a list of colors, avoiding the first few which are close to yellow
    # num_colors = 6
    # colors = generate_gradient(colorant"blue", colorant"black", num_colors)  # Generate a few extra colors
    colors = [
        RGB(0.933, 0.867, 0.512),  # Light yellow
    RGB(0.255, 0.412, 0.882),  # Blue
    RGB(0.804, 0.361, 0.361),  # Red
    RGB(0.420, 0.557, 0.137),  # Green
    RGB(0.545, 0.000, 0.000),  # Dark red
    RGB(0.686, 0.933, 0.933),  # Pale turquoise
    RGB(0.729, 0.333, 0.827),  # Violet
    RGB(0.847, 0.749, 0.847),  # Lavender
    RGB(0.933, 0.510, 0.933)   # Pale violet red
    ]
end


begin
    # for s1 and s2, first index represents tier: premaster/intermediate/candidate, 
    # second index represents year: 2024/2025/2026
    s0 = [2664, 2863, 3076]
    s1 = [2664 .* [1.03, 1.03^2, 1.03^3],
        2863 .* [1.03, 1.03^2, 1.03^3],
        3076 .* [1.03, 1.03^2, 1.03^3]]
    s2 = [2664 .* [1.12, 1.12*1.1, 1.12*1.1^2],
    2863 .* [1.095, 1.095*1.1, 1.095*1.1^2],
    3076 .* [1.07, 1.07*1.1, 1.07*1.1^2]]


    # Real Salaries
    previous_salaries = [
                        [s0[3], s1[3][1], NaN, NaN, NaN, NaN, NaN],
                        [s0[2], s1[2][1], s1[3][1], s1[3][2] , NaN, NaN, NaN],
                        [s0[2], s1[2][1], s1[2][1], s1[2][2], s1[3][2], s1[3][3], NaN],
                        [s0[2], s1[2][1], s1[2][1], s1[2][2], s1[2][2], s1[2][3], s1[3][3]],
                        [s0[1], s1[1][1], s1[1][1], s1[2][2], s1[2][2], s1[2][3], s1[2][3]],
                        [s0[1], s1[1][1], s1[1][1], s1[1][2], s1[1][2], s1[2][3], s1[2][3]]
                        ]

    proposed_salaries = [
                        [s0[3], s2[3][1], NaN, NaN, NaN, NaN, NaN],
                        [s0[2], s2[2][1], s2[3][1], s2[3][2] , NaN, NaN, NaN],
                        [s0[2], s2[2][1], s2[2][1], s2[2][2], s2[3][2], s2[3][3], NaN],
                        [s0[2], s2[2][1], s2[2][1], s2[2][2], s2[2][2], s2[2][3], s2[3][3]],
                        [s0[1], s2[1][1], s2[1][1], s2[2][2], s2[2][2], s2[2][3], s2[2][3]],
                        [s0[1], s2[1][1], s2[1][1], s2[1][2], s2[1][2], s2[2][3], s2[2][3]]
                        ]
    
end

begin
    # Set the plot size and DPI
    default(size=(1000, 1000), dpi=300)  # Adjust size and DPI here


    Random.seed!(1334)  # Set the seed for reproducibility
    line_widths = [1 + rand()/2 for _ in 1:6]

    # # Generate a list of colors
    # colors = distinguishable_colors(6)

    # Timeline for x ticks
    xtick_labels = ["Before July 1st 2024", "July 1st 2024", "Jan. 1st 2025", "July 1st 2025", "Jan. 1st 2026", "July 1st 2026", "Jan. 1st 2027"]

    # Create the plot
    p1 = plot(xticks=(1:7, xtick_labels))  # Set custom x-tick labels
    label_prop = ["Proposed, Enrolled in 2019 Fall",
                "Proposed, Enrolled in 2020 Fall",
                "Proposed, Enrolled in 2021 Fall",
                "Proposed, Enrolled in 2022 Fall",
                "Proposed, Enrolled in 2023 Fall",
                "Proposed, Enrolled in 2024 Fall"]
    label_prev = ["Previous, Enrolled in 2019 Fall",
                "Previous, Enrolled in 2020 Fall",
                "Previous, Enrolled in 2021 Fall",
                "Previous, Enrolled in 2022 Fall",
                "Previous, Enrolled in 2023 Fall",
                "Previous, Enrolled in 2024 Fall"]

    # Plot salaries with solid lines
    for i in 1:6
        plot!(p1, proposed_salaries[i], label=label_prop[i], color=colors[i], linewidth = 1.5 .* line_widths[i], linestyle=:dot)
        plot!(p1, previous_salaries[i], label=label_prev[i], color=colors[i], alpha = 0.5, linewidth = 1.5 .* line_widths[i], linestyle=:solid)
    end


    for x in 1:7
        vline!([x], line=:dash, color=:black, alpha=0.5, label = "")
    end

    xlabel!(p1, "Timeline")
    ylabel!(p1, "Salary")
    title!(p1, "Cumulated Salaries by Enrollment Year")

    # Display the plot
    display(p1)
end



begin
    # Data
    years = 2019:2024
    # Calculate the sum of non-NaN values in proposed_salaries
    sum_proposed = Array{Float64}(undef, 6)
    sum_previous = Array{Float64}(undef, 6)

    for i in 1:6
        prop_valid_values = filter(!isnan, proposed_salaries[i][2:end])
        sum_proposed[i] = sum(prop_valid_values) .* 6
        prev_valid_values = filter(!isnan, previous_salaries[i][2:end])
        sum_previous[i] = sum(prev_valid_values) .* 6
    end

end

begin
    cumulated_proposed_salaries = sum_proposed
    cumulated_previous_salaries = sum_previous



    # Custom y-tick labels
    ytick_labels = ["20,000\$", "40,000\$", "60,000\$", "80,000\$", "100,000\$", "120,000\$", "140,000\$"]
    ytick_positions = 20000:20000:140000

    # Custom labels for the legends
    previous_salary_labels = ["Previous Salary 2019", "Previous Salary 2020", "Previous Salary 2021", 
    "Previous Salary 2022", "Previous Salary 2023", "Previous Salary 2024"]
    proposed_salary_labels = ["Proposed Salary 2019", "Proposed Salary 2020", "Proposed Salary 2021", 
    "Proposed Salary 2022", "Proposed Salary 2023", "Proposed Salary 2024"]




    # Create the bar plot
    p2 = bar(legend=:topleft, yticks=(ytick_positions, ytick_labels))
    # Overlay the proposed salaries with dashed bars
    for i in 1:6
        bar!(p2, years[i:i], [cumulated_previous_salaries[i]], label=label_prev[i], color=colors[i], alpha=0.7)
        bar!(p2, years[i:i], [cumulated_proposed_salaries[i]], label=label_prop[i], color=colors[i], line=:dash, alpha=1, fillalpha=0)
    end
    plot!(p2, legendfontsize = 8)
    # Customize the plot
    xlabel!("Year")
    ylabel!("Salary")
    title!("Cumulated Salaries by Year")

    # Display the plot
    display(p2)
end


begin
    sum_diff =  sum_proposed - sum_previous
    perc_diff = sum_diff ./ sum_previous .* 100
end