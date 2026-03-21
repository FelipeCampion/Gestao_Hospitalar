# 🏥 Hospital-Management-System 🩺💉📊

![MySQL](https://img.shields.io/badge/mysql-%2300f.svg?style=for-the-badge&logo=mysql&logoColor=white)
![Status](https://img.shields.io/badge/Status-Completed-brightgreen?style=for-the-badge)

**Relational Intelligence System for Clinical Management, Laboratory Automation, and Patient Safety.**

This project features a robust database infrastructure designed for the digitalization of hospital workflows. The key differentiator is the **active clinical monitoring layer**, where the database does not just store medical records but also audits laboratory deadlines and flags life-threatening risks in real-time through automated triggers.

---

## Architecture & Technology

* **Engine:** MySQL 8.0+
* **Concepts Applied:** Many-to-Many Relationships (Prescription Items), Strict Referential Integrity, Trigger-based Automation, and Critical Event Logging (Audit Trail).
* **Focus:** Patient safety, SLA compliance (Service Level Agreement), and diagnostic traceability.

---

## Intelligence & Implemented Automations

### Audited Laboratory Workflow (Triggers)
* **SLA Monitoring:** Through the `trg_finalizar_exame` trigger, the system acts as a quality auditor. It compares the completion date with the deadline set in the exam request. If the result is submitted outside the expected window, the status is automatically updated to **'Overdue' (Atrasado)**, allowing for the generation of Hospital Performance Indicators (KPIs).

### Clinical Alert Algorithm (Patient Safety)
The `trg_alerta_piora` trigger implements a rapid response protocol for cases of clinical decline:
* **Visual Risk Flagging:** Dynamically modifies the patient's record by inserting the `[ALERT!]` flag into their name, ensuring that any simple database query immediately highlights high-risk patients to reception and nursing staff.
* **Automated Triage:** Simultaneously populates the `critical_state` (estado_critico) table, creating a priority queue for the medical team based strictly on real-time clinical evolution data.

### Structured Medication Management
* **Pharmacy Normalization:** Implementation of the relationship between medications and medical records via the `prescription_items` (itens_prescricao) table, allowing for multiple dosages and frequencies per visit, preventing medication errors, and streamlining inventory control.

---

## How to Reproduce the Tests

1.  Run the structure script (**DDL**) to create the hospital ecosystem and business rules.
2.  Use the **Test DML** script to populate Doctors and Patients.
3.  Simulate a risk alert by inserting an evolution with a "Decline" (Piora) status:
4.  Validate the database intelligence by running the following queries:

```sql
-- Simulate clinical decline
INSERT INTO evolucao_paciente (id_paciente, id_consulta, status_progresso) 
VALUES (1, 1, 'Piora');

-- 1. Check the Critical Triage Queue (Audit Trail)
SELECT * FROM estado_critico;

-- 2. Verify automatic visual signaling in the patient registry
SELECT nome_paciente FROM pacientes WHERE id_paciente = 1;
