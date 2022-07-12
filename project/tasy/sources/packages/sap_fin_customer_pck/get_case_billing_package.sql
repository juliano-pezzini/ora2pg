-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


/*-----------------------------------------------------------------------------------------------------------------------------------------------------------------
Z_CO_INXTORDER - CASE / Billing
*/
CREATE OR REPLACE FUNCTION sap_fin_customer_pck.get_case_billing ( nr_seq_fila_p bigint) RETURNS SETOF T_GET_CASE_BILLING AS $body$
DECLARE


nr_seq_documento_w			intpd_fila_transmissao.nr_seq_documento%type;
ie_conversao_w				intpd_eventos_sistema.ie_conversao%type;
nr_seq_sistema_w			intpd_eventos_sistema.nr_seq_sistema%type;
nr_seq_projeto_xml_w		intpd_eventos_sistema.nr_seq_projeto_xml%type;
nr_seq_regra_w				intpd_eventos_sistema.nr_seq_regra_conv%type;
r_get_case_billing_w		r_get_case_billing;
reg_integracao_w			gerar_int_padrao.reg_integracao_conv;
pessoa_fisica_w				pessoa_fisica%rowtype;
nm_pais_w					pais.nm_pais%type;
dt_nascimento_w				pessoa_fisica.dt_nascimento%type;
dt_entrada_w				episodio_paciente.dt_episodio%type;
nm_medico_w					varchar(60);

c01 CURSOR FOR
	SELECT	nr_sequencia,
			nr_episodio,
			cd_pessoa_fisica,
			dt_episodio,
			cd_medico_referido
	from	episodio_paciente
	where	nr_sequencia = nr_seq_documento_w
	and		coalesce(dt_cancelamento::text, '') = '';

c01_w	c01%rowtype;


BEGIN
intpd_reg_integracao_inicio(nr_seq_fila_p, 'E', reg_integracao_w);

select	a.nr_seq_documento,
		coalesce(b.ie_conversao,'I'),
		b.nr_seq_sistema,
		b.nr_seq_projeto_xml,
		b.nr_seq_regra_conv
into STRICT	nr_seq_documento_w,
		ie_conversao_w,
		nr_seq_sistema_w,
		nr_seq_projeto_xml_w,
		nr_seq_regra_w
from	intpd_fila_transmissao a,
		intpd_eventos_sistema b
where	a.nr_seq_evento_sistema = b.nr_sequencia
and		a.nr_sequencia = nr_seq_fila_p;

open C01;
loop
fetch C01 into
	c01_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
		r_get_case_billing_w			:=	null;
		reg_integracao_w.nm_tabela 		:=	'EPISODIO_PACIENTE';
		reg_integracao_w.nm_elemento	:=	'Z_CO_INTORDER';

		intpd_processar_atrib_envio(reg_integracao_w, 'NR_SEQUENCIA', 'IV_FALLNR', 'N', c01_w.nr_sequencia, 'N', r_get_case_billing_w.iv_fallnr);
		intpd_processar_atrib_envio(reg_integracao_w, 'NR_EPISODIO', 'IV_FALLTXT', 'N', c01_w.nr_episodio, 'N', r_get_case_billing_w.iv_falltxt);
		intpd_processar_atrib_envio(reg_integracao_w, 'CD_PESSOA_FISICA', 'IV_PAT_ID', 'N', c01_w.cd_pessoa_fisica, 'N', r_get_case_billing_w.iv_pat_id);

		begin
		select	*
		into STRICT	pessoa_fisica_w
		from	pessoa_fisica
		where	cd_pessoa_fisica	=	c01_w.cd_pessoa_fisica;
		exception
		when others then
			pessoa_fisica_w.cd_pessoa_fisica := null;
		end;

		intpd_processar_atrib_envio(reg_integracao_w, 'NM_PRIMEIRO_NOME', 'IV_FIRSTNAME', 'N', pessoa_fisica_w.nm_primeiro_nome, 'N', r_get_case_billing_w.iv_firstname);
		intpd_processar_atrib_envio(reg_integracao_w, 'NM_PESSOA_FISICA', 'IV_LASTNAME', 'N', pessoa_fisica_w.nm_pessoa_fisica, 'N', r_get_case_billing_w.iv_lastname);

		begin
		dt_nascimento_w		:=	to_char(pessoa_fisica_w.dt_nascimento,'yyyy-mm-dd');
		exception
		when others then
			dt_nascimento_w	:=	null;
		end;
		intpd_processar_atrib_envio(reg_integracao_w, 'X', 'IV_BIRTHDATE', 'N', dt_nascimento_w, 'N', r_get_case_billing_w.iv_birthdate);

		begin
		dt_entrada_w		:=	to_char(c01_w.dt_episodio,'yyyy-mm-dd');
		exception
		when others then
			dt_entrada_w	:=	null;
		end;
		intpd_processar_atrib_envio(reg_integracao_w, 'DT_EPISODIO', 'IV_DATEFROM', 'N', dt_entrada_w, 'N', r_get_case_billing_w.iv_datefrom);

		begin
		select	substr(obter_nome_medico(c01_w.cd_medico_referido, 'N'),1,60)
		into STRICT	nm_medico_w
		;
		exception
		when others then
			nm_medico_w		:=	null;
		end;
		intpd_processar_atrib_envio(reg_integracao_w, 'NM_MEDICO', 'IV_PHYSICIAN', 'N', nm_medico_w, 'N', r_get_case_billing_w.iv_physician);

		/*
    
    intpd_processar_atrib_envio(reg_integracao_w, 'X','IV_KOKRS', 'N', 'c01_w.', 'N', r_get_case_billing_w.iv_kokrs);
		intpd_processar_atrib_envio(reg_integracao_w, 'X','IV_BUKRS', 'N', 'c01_w.', 'N', r_get_case_billing_w.iv_bukrs);
		intpd_processar_atrib_envio(reg_integracao_w, 'X','IV_TEST', 'N', 'c01_w.', 'N', r_get_case_billing_w.iv_test);*/
		RETURN NEXT r_get_case_billing_w;
	end;
end loop;
close C01;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION sap_fin_customer_pck.get_case_billing ( nr_seq_fila_p bigint) FROM PUBLIC;
