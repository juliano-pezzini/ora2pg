-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


/*-----------------------------------------------------------------------------------------------------------------------------------------------------------------
'PatcaseCanceldischarge'
*/
CREATE OR REPLACE FUNCTION ish_pat_case_pck.get_cancel_discharge ( nr_seq_fila_p bigint) RETURNS SETOF T_CANCEL_DISCHARGE AS $body$
DECLARE

		
r_cancel_discharge_w		r_cancel_discharge;

nr_seq_documento_w		intpd_fila_transmissao.nr_seq_documento%type;
ie_conversao_w			intpd_eventos_sistema.ie_conversao%type;
nr_seq_regra_w			intpd_eventos_sistema.nr_seq_regra_conv%type;

nr_atendimento_w			atendimento_paciente.nr_atendimento%type;
cd_estabelecimento_w		estabelecimento.cd_estabelecimento%type;
cd_empresa_w			empresa.cd_empresa%type;
cd_pessoa_fisica_w		pessoa_fisica.cd_pessoa_fisica%type;
reg_integracao_w		gerar_int_padrao.reg_integracao_conv;
nr_episodio_w			episodio_paciente.nr_episodio%type;


BEGIN
select	a.nr_seq_documento,
	coalesce(b.ie_conversao,'I'),
	b.nr_seq_regra_conv
into STRICT	nr_seq_documento_w,
	ie_conversao_w,	
	nr_seq_regra_w
from	intpd_fila_transmissao a,
	intpd_eventos_sistema b
where	a.nr_seq_evento_sistema = b.nr_sequencia
and	a.nr_sequencia = nr_seq_fila_p;

intpd_reg_integracao_inicio(nr_seq_fila_p, 'E', reg_integracao_w);
reg_integracao_w.nm_elemento			:= 'PatcaseCanceldischarge';

begin
select	b.nr_episodio,
	a.cd_pessoa_fisica,
	a.cd_estabelecimento
into STRICT	nr_episodio_w,
	cd_pessoa_fisica_w,
	cd_estabelecimento_w
FROM atendimento_paciente a
LEFT OUTER JOIN episodio_paciente b ON (a.nr_seq_episodio = b.nr_sequencia)
WHERE a.nr_atendimento = nr_seq_documento_w;

reg_integracao_w.nm_tabela 	:= 'EPISODIO_PACIENTE';
intpd_processar_atrib_envio(reg_integracao_w, 'NR_EPISODIO', 'patcaseid', 'N', nr_episodio_w, 'N', r_cancel_discharge_w.patcaseid);

select	cd_empresa
into STRICT	cd_empresa_w
from	estabelecimento
where	cd_estabelecimento = cd_estabelecimento_w;

reg_integracao_w.nm_tabela 	:= 'ESTABELECIMENTO';
intpd_processar_atrib_envio(reg_integracao_w, 'CD_EMPRESA', 'client', 'N', cd_empresa_w, 'S', r_cancel_discharge_w.client);
reg_integracao_w.nm_tabela 	:= 'ATENDIMENTO_PACIENTE';
intpd_processar_atrib_envio(reg_integracao_w, 'CD_ESTABELECIMENTO', 'institution', 'N', cd_estabelecimento_w, 'S', r_cancel_discharge_w.institution);
exception
when others then
	null;
end;

RETURN NEXT r_cancel_discharge_w;
CALL intpd_gravar_log_fila(reg_integracao_w);
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION ish_pat_case_pck.get_cancel_discharge ( nr_seq_fila_p bigint) FROM PUBLIC;
