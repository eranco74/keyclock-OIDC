# Define the environment file
ENV_FILE = .env

# Load the environment variables from the file
include $(ENV_FILE)
export $(shell sed 's/=.*//' $(ENV_FILE))

# Define the files that need envsubst
TEMPLATE_FILES = resty/nginx.conf resty/callback.lua resty/auth.lua keyclock/realm.json

# Define the output directory
OUTPUT_DIR = output

# Create the output directory if it doesn't exist
$(OUTPUT_DIR):
	mkdir -p $(OUTPUT_DIR)

# Generate the output files with substituted values
define GENERATE_RULE
$(OUTPUT_DIR)/$(notdir $(1)): $(1) | $(OUTPUT_DIR)
	envsubst < $(1) > $(OUTPUT_DIR)/$(notdir $(1))
endef

$(foreach template,$(TEMPLATE_FILES),$(eval $(call GENERATE_RULE,$(template))))

# Generate all files
.PHONY: generate
generate: $(foreach template,$(TEMPLATE_FILES),$(OUTPUT_DIR)/$(notdir $(template)))

# Clean up generated files
.PHONY: clean
clean:
	rm -rf $(OUTPUT_DIR)

# Run the entire workflow
.PHONY: deploy
deploy: generate
	podman-compose up --build

