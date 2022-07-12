-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION ish_diagnosis_pck.get_case_diagnosis_getlist ( nr_seq_fila_p bigint) RETURNS SETOF T_CASE_DIAGNOSIS_GETLIST AS $body$
DECLARE


nr_seq_documento_w		intpd_fila_transmissao.nr_seq_documento%type;
nr_seq_regra_w			intpd_eventos_sistema.nr_seq_regra_conv%type;
ie_conversao_w			intpd_eventos_sistema.ie_conversao%type;
caseno_w			hcm_fall.caseno%type;
nr_atendimento_w		atendimento_paciente.nr_atendimento%type;
cd_estabelecimento_w		estabelecimento.cd_estabelecimento%type;
r_case_diagnosis_getlist_w	r_case_diagnosis_getlist;
patientno_w			hcm_patienten.patientno%type;
movenumber_w			hcm_fall.movenumber%type;
sendclient_w			hcm_kopf.sendclient%type;
ie_geracao_w			intpd_fila_transmissao.ie_geracao%type;


BEGIN
select	a.nr_seq_documento,
	b.nr_seq_regra_conv,
	coalesce(b.ie_conversao,'I'),
	a.ie_geracao
into STRICT	nr_seq_documento_w,
	nr_seq_regra_w,
	ie_conversao_w,
	ie_geracao_w
from	intpd_fila_transmissao a,
	intpd_eventos_sistema b
where	a.nr_seq_evento_sistema = b.nr_sequencia
and	a.nr_sequencia = nr_seq_fila_p;

if (ie_geracao_w = 'U') then
	ish_get_manual_values(nr_seq_fila_p, patientno_w, caseno_w, movenumber_w, sendclient_w, r_case_diagnosis_getlist_w.institution);
else
	begin
	select	caseno,
		institute
	into STRICT	caseno_w,
		r_case_diagnosis_getlist_w.institution
	from	hcm_fall
	where	nr_sequencia = nr_seq_documento_w;

	nr_atendimento_w := ish_get_encounter_case(caseno_w, null);

	select	cd_estabelecimento
	into STRICT	cd_estabelecimento_w
	from	atendimento_paciente
	where	nr_atendimento = nr_atendimento_w;
	
	if (coalesce(r_case_diagnosis_getlist_w.institution::text, '') = '') then
		begin
		r_case_diagnosis_getlist_w.institution	:=	intpd_conv('ESTABELECIMENTO', 'CD_ESTABELECIMENTO', cd_estabelecimento_w, nr_seq_regra_w, ie_conversao_w, 'E');
		exception
		when others then
			r_case_diagnosis_getlist_w.institution	:=	null;
		end;
	end if;
	end;
end if;

r_case_diagnosis_getlist_w.cancelledincl	:=	'X';
r_case_diagnosis_getlist_w.patcaseid		:=	caseno_w;

RETURN NEXT r_case_diagnosis_getlist_w;
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION ish_diagnosis_pck.get_case_diagnosis_getlist ( nr_seq_fila_p bigint) FROM PUBLIC;