-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE obter_ultimo_laudo_proced ( nr_seq_laudo_atual_p bigint, nr_seq_ultimo_laudo_p INOUT bigint, nr_atendimento_laudo_p INOUT bigint) AS $body$
DECLARE

				    
cd_pessoa_fisica_w	varchar(10);
cd_procedimento_w	bigint;
ie_origem_proced_w	bigint;
nr_seq_proc_interno_w	bigint;
nr_seq_ultimo_laudo_w	bigint;

 

BEGIN 
 
select	max(substr(obter_dados_atendimento(nr_atendimento,'CP'),1,10)) cd_pessoa_fisica, 
	max(b.cd_procedimento), 
	max(b.ie_origem_proced), 
	max(b.nr_seq_proc_interno) 
into STRICT	cd_pessoa_fisica_w, 
    cd_procedimento_w,	 
    ie_origem_proced_w,	 
	nr_seq_proc_interno_w 
from	laudo_paciente a, 
	prescr_procedimento b 
where	a.nr_prescricao = b.nr_prescricao 
and	b.nr_sequencia = a.nr_seq_prescricao 
and	a.nr_sequencia = nr_seq_laudo_atual_p;
 
 
if ( coalesce(nr_seq_proc_interno_w::text, '') = '') then 
 
	select	max(c.nr_sequencia) nr_sequencia 
	into STRICT	nr_seq_ultimo_laudo_w 
	from	prescr_procedimento a, 
		prescr_medica b, 
		laudo_paciente c 
	where 	c.nr_prescricao = b.nr_prescricao 
	and	c.nr_seq_prescricao = a.nr_sequencia 
	and	a.nr_prescricao = b.nr_prescricao 
	and	a.cd_procedimento = cd_procedimento_w 
	and	a.ie_origem_proced = ie_origem_proced_w 
	and	b.cd_pessoa_fisica = cd_pessoa_fisica_w 
	and	c.nr_sequencia <> nr_seq_laudo_atual_p;
 
else 
 
	select	max(c.nr_sequencia) nr_sequencia 
	into STRICT	nr_seq_ultimo_laudo_w 
	from	prescr_procedimento a, 
		prescr_medica b, 
		laudo_paciente c 
	where 	c.nr_prescricao = b.nr_prescricao 
	and	c.nr_seq_prescricao = a.nr_sequencia 
	and	a.nr_prescricao = b.nr_prescricao 
	and	a.nr_seq_proc_interno = nr_seq_proc_interno_w 
	and	b.cd_pessoa_fisica = cd_pessoa_fisica_w 
	and	c.nr_sequencia <> nr_seq_laudo_atual_p;
 
end if;
 
select	max(nr_atendimento), 
	max(nr_sequencia) 
into STRICT	nr_atendimento_laudo_p, 
	nr_seq_ultimo_laudo_p	 
from	laudo_paciente 
where	nr_sequencia = nr_seq_ultimo_laudo_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE obter_ultimo_laudo_proced ( nr_seq_laudo_atual_p bigint, nr_seq_ultimo_laudo_p INOUT bigint, nr_atendimento_laudo_p INOUT bigint) FROM PUBLIC;

