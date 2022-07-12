-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION ish_pat_case_pck.get_assignment ( nr_seq_fila_p bigint) RETURNS SETOF T_ASSIGNMENT AS $body$
DECLARE

		
r_assignment_w			r_assignment;

reg_integracao_w		gerar_int_padrao.reg_integracao_conv;
nr_seq_documento_w		intpd_fila_transmissao.nr_seq_documento%type;

nr_seq_ep_paciente_w		episodio_acompanhante.nr_seq_ep_paciente%type;
nr_seq_ep_acompanhante_w	episodio_acompanhante.nr_seq_ep_acompanhante%type;

nr_episodio_paciente_w		episodio_paciente.nr_episodio%type;
nr_episodio_acompanhante_w	episodio_paciente.nr_episodio%type;

cd_estabelecimento_w		estabelecimento.cd_estabelecimento%type;
cd_empresa_w			estabelecimento.cd_empresa%type;


BEGIN
begin
select	a.nr_seq_documento
into STRICT	nr_seq_documento_w
from	intpd_fila_transmissao a,
	intpd_eventos_sistema b
where	a.nr_seq_evento_sistema = b.nr_sequencia
and	a.nr_sequencia = nr_seq_fila_p;
exception
when others then
	nr_seq_documento_w	:=	null;
end;

intpd_reg_integracao_inicio(nr_seq_fila_p, 'E', reg_integracao_w);
reg_integracao_w.nm_elemento	:= '_-rzvish_-assignment';


nr_seq_ep_paciente_w		:=	somente_numero(obter_valor_campo_separador(nr_seq_documento_w, 1, '|'));
nr_seq_ep_acompanhante_w	:=	somente_numero(obter_valor_campo_separador(nr_seq_documento_w, 2, '|'));

begin
select	cd_estabelecimento
into STRICT	cd_estabelecimento_w
from	episodio_paciente
where	nr_sequencia = nr_seq_ep_paciente_w
and	(cd_estabelecimento IS NOT NULL AND cd_estabelecimento::text <> '');
exception
when others then
	begin
	select	cd_estabelecimento
	into STRICT	cd_estabelecimento_w
	from	atendimento_paciente
	where	nr_seq_episodio = nr_seq_ep_paciente_w  LIMIT 1;
	exception
	when others then
		cd_estabelecimento_w	:=	obter_estabelecimento_ativo;
	end;
end;

begin
select	nr_episodio
into STRICT	nr_episodio_paciente_w
from	episodio_paciente
where	nr_sequencia = nr_seq_ep_paciente_w;
exception
when others then
	nr_episodio_paciente_w	:=	null;
end;

begin
select	nr_episodio
into STRICT	nr_episodio_acompanhante_w
from	episodio_paciente
where	nr_sequencia = nr_seq_ep_acompanhante_w;
exception
when others then
	nr_episodio_acompanhante_w	:=	null;
end;

begin
select	cd_empresa
into STRICT	cd_empresa_w
from	estabelecimento
where	cd_estabelecimento = cd_estabelecimento_w;
exception
when others then
	cd_empresa_w	:=	null;
end;
	
reg_integracao_w.nm_tabela	:= 'ESTABELECIMENTO';
intpd_processar_atrib_envio(reg_integracao_w, 'CD_EMPRESA', 'client', 'N', cd_empresa_w, 'S', r_assignment_w.client);
intpd_processar_atrib_envio(reg_integracao_w, 'CD_ESTABELECIMENTO', 'institution', 'N', cd_estabelecimento_w, 'S', r_assignment_w.institution);

reg_integracao_w.nm_tabela	:= 'EPISODIO_PACIENTE';
intpd_processar_atrib_envio(reg_integracao_w, 'NR_EPISODIO', 'PATCASEID1', 'N', nr_episodio_paciente_w, 'N', r_assignment_w.patcaseid1);
intpd_processar_atrib_envio(reg_integracao_w, 'NR_EPISODIO', 'PATCASEID2', 'N', nr_episodio_acompanhante_w, 'N', r_assignment_w.patcaseid2);

RETURN NEXT r_assignment_w;

CALL intpd_gravar_log_fila(reg_integracao_w);
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION ish_pat_case_pck.get_assignment ( nr_seq_fila_p bigint) FROM PUBLIC;