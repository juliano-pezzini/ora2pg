-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


/*-----------------------------------------------------------------------------------------------------------------------------------------------------------------
'_-rzvish_-insuranceCancel'
*/
CREATE OR REPLACE FUNCTION ish_rzv_insurance_pck.get_insurance_cancel (nr_seq_fila_p bigint) RETURNS SETOF T_INSURANCE_CANCEL AS $body$
DECLARE


cd_empresa_w			estabelecimento.cd_empresa%type;
cd_estabelecimento_w		estabelecimento.cd_estabelecimento%type;
nr_episodio_w			episodio_paciente.nr_episodio%type;
ie_conversao_w			intpd_eventos_sistema.ie_conversao%type;
nr_seq_regra_w			intpd_eventos_sistema.nr_seq_regra_conv%type;
nr_seq_interno_w		atend_categoria_convenio.nr_seq_interno%type;
nr_atendimento_w		atend_categoria_convenio.nr_atendimento%type;
nr_seq_documento_w		intpd_fila_transmissao.nr_seq_documento%type;
r_insurance_cancel_w		r_insurance_cancel;
reg_integracao_w		gerar_int_padrao.reg_integracao_conv;
nr_seq_interno_ret_w		varchar(80);
nr_seq_episodio_w		episodio_paciente.nr_sequencia%type;
current_setting('ish_rzv_insurance_pck.ds_separador_w')::varchar(10)			varchar(10)	:= ish_param_pck.get_separador;
cd_convenio_w			atend_categoria_convenio.cd_convenio%type;


BEGIN

begin
select	a.nr_seq_documento,
	coalesce(b.ie_conversao,'I'),
	b.nr_seq_regra_conv
into STRICT	nr_seq_documento_w,
	ie_conversao_w,
	nr_seq_regra_w
from	intpd_fila_transmissao a,
	intpd_eventos_sistema b
where	a.nr_seq_evento_sistema = b.nr_sequencia
and	a.nr_sequencia	= nr_seq_fila_p;
exception
when others then
	null;
end;

intpd_reg_integracao_inicio(nr_seq_fila_p, 'E', reg_integracao_w);



nr_atendimento_w	:=	obter_valor_campo_separador(nr_seq_documento_w, 1, current_setting('ish_rzv_insurance_pck.ds_separador_w')::varchar(10));
nr_seq_interno_w	:=	obter_valor_campo_separador(nr_seq_documento_w, 2, current_setting('ish_rzv_insurance_pck.ds_separador_w')::varchar(10));
nr_seq_episodio_w	:=	obter_valor_campo_separador(nr_seq_documento_w, 3, current_setting('ish_rzv_insurance_pck.ds_separador_w')::varchar(10));

begin
select	a.cd_empresa,
	a.cd_estabelecimento,
	lpad(c.nr_episodio,10,'0') nr_episodio
into STRICT	cd_empresa_w,
	cd_estabelecimento_w,
	nr_episodio_w
FROM estabelecimento a, atendimento_paciente b
LEFT OUTER JOIN episodio_paciente c ON (b.nr_seq_episodio = c.nr_sequencia)
WHERE a.cd_estabelecimento = b.cd_estabelecimento  and b.nr_atendimento = nr_atendimento_w;
exception
when others then
	select	nr_episodio
	into STRICT	nr_episodio_w
	from	episodio_paciente
	where	nr_sequencia	=	nr_seq_episodio_w;
	
	select	min(cd_estabelecimento)
	into STRICT	cd_estabelecimento_w
	from	estabelecimento;
	
	select	cd_empresa
	into STRICT	cd_empresa_w
	from	estabelecimento
	where	cd_estabelecimento = cd_estabelecimento_w;
end;

reg_integracao_w.nm_elemento	:= '_-rzvish_-insuranceCancel';
reg_integracao_w.nm_tabela	:= 'ESTABELECIMENTO';
intpd_processar_atrib_envio(reg_integracao_w, 'CD_EMPRESA', 'client', 'N', cd_empresa_w, 'S', r_insurance_cancel_w.client);
intpd_processar_atrib_envio(reg_integracao_w, 'CD_ESTABELECIMENTO', 'institution', 'N', cd_estabelecimento_w, 'S', r_insurance_cancel_w.institution);

reg_integracao_w.nm_tabela	:= 'EPISODIO_PACIENTE';
intpd_processar_atrib_envio(reg_integracao_w, 'NR_EPISODIO', 'patcaseid', 'N', nr_episodio_w, 'N', r_insurance_cancel_w.patcaseid);

reg_integracao_w.nm_tabela	:= 'ATEND_CATEGORIA_CONVENIO';
reg_integracao_w.nm_elemento	:= 'InsurDataCancel';
nr_seq_interno_ret_w		:= intpd_conv('ATEND_CATEGORIA_CONVENIO', 'NR_SEQ_INTERNO', nr_seq_interno_w, reg_integracao_w.nr_seq_regra_conversao, reg_integracao_w.ie_conversao, 'E');

if (coalesce(obter_valor_campo_separador(nr_seq_interno_ret_w, 2, current_setting('ish_rzv_insurance_pck.ds_separador_w')::varchar(10)),'NULL') = 'NULL') then
	select	max(somente_numero(obter_valor_campo_separador(b.ds_chave, 2, ';')))
	into STRICT	cd_convenio_w
	from	intpd_reg_alter_campo a,
		intpd_reg_alteracao b
	where	a.ds_valor_old	= to_char(nr_seq_interno_w)
	and	a.nr_sequencia	= b.nr_sequencia;

	select	max(intpd_conv('ATEND_CATEGORIA_CONVENIO', 'NR_SEQ_INTERNO', coalesce(b.ds_valor_new, b.ds_valor_old),
		reg_integracao_w.nr_seq_regra_conversao, reg_integracao_w.ie_conversao, 'E'))
	into STRICT	nr_seq_interno_ret_w
	from	intpd_reg_alteracao a,
		intpd_reg_alter_campo b
	where	a.nr_sequencia = b.nr_sequencia
	and	a.nm_tabela = 'ATEND_CATEGORIA_CONVENIO'
	and	b.nm_atributo = 'NR_SEQ_INTERNO'
	and	exists (	SELECT	1
		from	atendimento_paciente y,
			intpd_reg_alter_campo x
		where	y.nr_seq_episodio = nr_seq_episodio_w
		and	x.nr_sequencia = a.nr_sequencia
		and	coalesce(x.ds_valor_new, x.ds_valor_old) like to_char(y.nr_atendimento)
		and	x.nm_atributo = 'NR_ATENDIMENTO')
	and	exists (	select	1
		from	intpd_reg_alter_campo x
		where	x.nr_sequencia = a.nr_sequencia
		and	coalesce(x.ds_valor_new, x.ds_valor_old) like to_char(cd_convenio_w)
		and	x.nm_atributo = 'CD_CONVENIO');
		
	if (coalesce(nr_seq_interno_ret_w, 'NULL') = 'NULL') then
		intpd_processar_atrib_envio(reg_integracao_w, 'NR_SEQ_INTERNO', 'lfdnr', 'N', nr_seq_interno_w, 'S', nr_seq_interno_ret_w);
	end if;
end if;

r_insurance_cancel_w.lfdnr	:= obter_valor_campo_separador(nr_seq_interno_ret_w, 2, current_setting('ish_rzv_insurance_pck.ds_separador_w')::varchar(10));

RETURN NEXT r_insurance_cancel_w;
CALL intpd_gravar_log_fila(reg_integracao_w);
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION ish_rzv_insurance_pck.get_insurance_cancel (nr_seq_fila_p bigint) FROM PUBLIC;
