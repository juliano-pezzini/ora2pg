-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW tipo_macro_v (cd, ds) AS Select 'CD_EVOLUCAO' cd, 'Evolução' ds

union all

Select 'CD_PESSOA_FISICA' cd, 'Pessoa física' ds  

union all

Select 'CD_PESSOA_USUARIO'  cd, 'Pessoa usuário' ds 

union all

Select 'NR_ATENDIMENTO' cd,'Atendimento' ds 

union all

Select 'NR_CIRURGIA' cd,'Cirurgia' ds  

union all

Select 'NR_SEQ_AGENDA' cd,'Agenda'  

union all

Select 'SISTEMA' cd,'Sistema'  

union all

Select 'NR_LAUDO' cd,'Laudo Paciente'  

union all

Select 'NR_LAUDO_PATOLOGIA' cd,'Laudo Patologia'  

union all

Select 'IE_SUBS' cd,'Substituição'  

union all

select 'NR_SEQ_CONSULTA' cd, 'Consulta oft' 

union all

select 'NR_SEQ_CONSENTIMENTO' cd, 'Consentimento' 

union all

select 'NR_SEQ_ATESTADO' cd, 'Atestado' 

union all

select 'NR_PRESCRICAO' cd, 'Prescrição' 
order by 2;

