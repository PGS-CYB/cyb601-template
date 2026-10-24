# Labs

One folder per lab (`lab1/` through `lab7/`), plus `week0/` for the setup check.
Each folder holds the evidence the lab asks for and a `README.md` written from
the `_TEMPLATE.md` below.

## Submitting

```bash
git add labs/labN
git commit -m "Lab N: <summary>"
git push
git tag labN-submit && git push origin labN-submit
```

Then upload the 2-page report PDF to the LMS. Grading uses the engineering lab
rubric: working implementation (14), evidence (8), analysis and risk reasoning
(12), professional communication (6).

## Rules

- The lab must rebuild from a clean clone using this README.
- Keep secrets out of Git. Report any exposed secret within 24 hours.
- Disclose any AI use; analysis and conclusions are your own.