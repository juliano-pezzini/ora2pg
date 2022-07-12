-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION ish_pat_case_pck.get_assignment_get ( nr_seq_fila_p bigint) RETURNS SETOF T_ASSIGNMENT_GET AS $body$
DECLARE

		
r_assignment_get_w	r_assignment_get;
nr_seq_hcm_fall_w	hcm_fall.nr_sequencia%type;
nr_seq_mensagem_w	hcm_segmento.nr_seq_mensagem%type;
reg_integracao_w	gerar_int_padrao.reg_integracao_conv;
institute_w		hcm_fall.institute%type;
caseno_w		hcm_fall.caseno%type;
sendclient_w		hcm_kopf.sendclient%type;
ie_verif_w		varchar(1);
nr_seq_doc_w		intpd_fila_transmissao.nr_seq_documento%type;
ie_geracao_w		intpd_fila_transmissao.ie_geracao%type;
patientno_w		hcm_patienten.patientno%type;
movenumber_w		hcm_fall.movenumber%type;


BEGIN
begin
select	a.nr_seq_documento,
	a.ie_geracao
into STRICT	nr_seq_doc_w,
	ie_geracao_w
from	intpd_fila_transmissao a,
	intpd_eventos_sistema b
where	a.nr_seq_evento_sistema = b.nr_sequencia
and	a.nr_sequencia = nr_seq_fila_p;
exception
when others then
		nr_seq_doc_w	:=	null;
end;

intpd_reg_integracao_inicio(nr_seq_fila_p, 'E', reg_integracao_w);

reg_integracao_w.nm_elemento			:= '_-rzvish_-assignmentGet';

if (ie_geracao_w = 'U') then
	ish_get_manual_values(nr_seq_fila_p, patientno_w, caseno_w, movenumber_w, sendclient_w, institute_w);
else
	begin
	if (nr_seq_doc_w IS NOT NULL AND nr_seq_doc_w::text <> '') then
		begin
		begin
		select	a.institute,
			a.caseno,
			b.nr_seq_mensagem,
			'X'
		into STRICT	institute_w,
			caseno_w,
			nr_seq_mensagem_w,
			ie_verif_w
		from	hcm_fall a,
			hcm_segmento b
		where	a.nr_seq_segmento = b.nr_sequencia
		and	a.nr_sequencia = nr_seq_doc_w  LIMIT 1;
		exception
		when others then
			select	a.institute,
				a.caseno,
				b.nr_seq_mensagem,
				null
			into STRICT	institute_w,
				caseno_w,
				nr_seq_mensagem_w,
				ie_verif_w
			from	hcm_versicherungsverhaltni a,
				hcm_segmento b
			where	a.nr_seq_segmento = b.nr_sequencia
			and	a.nr_sequencia = nr_seq_doc_w  LIMIT 1;
		end;
				
		select	a.sendclient
		into STRICT	sendclient_w
		from	hcm_kopf a,
			hcm_segmento b
		where	a.nr_seq_segmento = b.nr_sequencia
		and	b.nr_seq_mensagem = nr_seq_mensagem_w;	
		end;
	end if;
	end;
end if;

if (ie_verif_w = 'X') then
	reg_integracao_w.nm_tabela	:= 'HCM_FALL';
else
	reg_integracao_w.nm_tabela	:= 'HCM_VERSICHERUNGSVERHALTNI';
end if;

intpd_processar_atrib_envio(reg_integracao_w, 'INSTITUTE', 'institution', 'N', institute_w, 'N', r_assignment_get_w.institution);
intpd_processar_atrib_envio(reg_integracao_w, 'CASENO', 'patcaseid', 'N', caseno_w, 'N', r_assignment_get_w.patcaseid);
reg_integracao_w.nm_tabela	:= 'HCM_KOPF';
intpd_processar_atrib_envio(reg_integracao_w, 'sendclient', 'client', 'N', sendclient_w, 'N', r_assignment_get_w.client);


RETURN NEXT r_assignment_get_w;
CALL intpd_gravar_log_fila(reg_integracao_w);
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION ish_pat_case_pck.get_assignment_get ( nr_seq_fila_p bigint) FROM PUBLIC;