-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


/*-----------------------------------------------------------------------------------------------------------------------------------------------------------------
'PatcaseCanceloutpatvisit'
*/
CREATE OR REPLACE FUNCTION ish_outpat_case_pck.get_patcase_cancel_outpat_vis ( nr_seq_fila_p bigint) RETURNS SETOF T_PATCASE_CANCEL_OUTPAT_VIS AS $body$
DECLARE


r_patcase_cancel_outpat_vis_w	r_patcase_cancel_outpat_vis;

ie_conversao_w			intpd_eventos_sistema.ie_conversao%type;
nr_seq_regra_w			intpd_eventos_sistema.nr_seq_regra_conv%type;

nr_atendimento_w		atendimento_paciente.nr_atendimento%type;
cd_estabelecimento_w		estabelecimento.cd_estabelecimento%type;
cd_empresa_w			empresa.cd_empresa%type;
cd_pessoa_fisica_w		pessoa_fisica.cd_pessoa_fisica%type;
movemntseqno_w			varchar(100);
nr_seq_atepacu_w		atend_paciente_unidade.nr_seq_interno%type;
reg_integracao_w		gerar_int_padrao.reg_integracao_conv;


BEGIN
select	somente_numero(a.nr_seq_documento),
	coalesce(b.ie_conversao,'I'),
	b.nr_seq_regra_conv
into STRICT	nr_atendimento_w,
	ie_conversao_w,	
	nr_seq_regra_w
from	intpd_fila_transmissao a,
	intpd_eventos_sistema b
where	a.nr_seq_evento_sistema = b.nr_sequencia
and	a.nr_sequencia = nr_seq_fila_p;

begin
select	b.nr_episodio,
	a.cd_pessoa_fisica,
	a.cd_estabelecimento
into STRICT	r_patcase_cancel_outpat_vis_w.patcaseid,
	cd_pessoa_fisica_w,
	cd_estabelecimento_w
FROM atendimento_paciente a
LEFT OUTER JOIN episodio_paciente b ON (a.nr_seq_episodio = b.nr_sequencia)
WHERE a.nr_atendimento = nr_atendimento_w;

intpd_reg_integracao_inicio(nr_seq_fila_p, 'E', reg_integracao_w);
reg_integracao_w.nm_tabela 			:= 'ATEND_PACIENTE_UNIDADE';
reg_integracao_w.nm_elemento			:= 'urn:PatcaseCanceloutpatvisit';

nr_seq_atepacu_w	:= obter_atepacu_paciente(nr_atendimento_w,'P');
--obtem a sequencia externa do nr_seq_atepacu que foi importado se existir
intpd_processar_atrib_envio(reg_integracao_w, 'NR_SEQ_INTERNO', 'movemntseqno', 'N', nr_seq_atepacu_w, 'S', movemntseqno_w);
--o retorno desta function sera patcaseid || ';' || movemntseqno (exemplo 000321321;00044532) e precisamos apenas do movemntseqno
if (movemntseqno_w IS NOT NULL AND movemntseqno_w::text <> '') then
	intpd_processar_atrib_envio(reg_integracao_w, 'NR_SEQ_INTERNO', 'movemntseqno', 'N', obter_valor_campo_separador(movemntseqno_w,2,current_setting('ish_outpat_case_pck.ds_separador_w')::varchar(10)), 'N', r_patcase_cancel_outpat_vis_w.movemntseqno);
end if;

select	cd_empresa
into STRICT	cd_empresa_w
from	estabelecimento
where	cd_estabelecimento = cd_estabelecimento_w;

reg_integracao_w.nm_tabela 	:= 'ESTABELECIMENTO';
intpd_processar_atrib_envio(reg_integracao_w, 'CD_EMPRESA', 'client', 'N', cd_empresa_w, 'S', r_patcase_cancel_outpat_vis_w.client);
reg_integracao_w.nm_tabela 	:= 'ATENDIMENTO_PACIENTE';
intpd_processar_atrib_envio(reg_integracao_w, 'CD_ESTABELECIMENTO', 'institution', 'N', cd_estabelecimento_w, 'S', r_patcase_cancel_outpat_vis_w.institution);
exception
when others then
	null;
end;

RETURN NEXT r_patcase_cancel_outpat_vis_w;
CALL intpd_gravar_log_fila(reg_integracao_w);

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION ish_outpat_case_pck.get_patcase_cancel_outpat_vis ( nr_seq_fila_p bigint) FROM PUBLIC;
