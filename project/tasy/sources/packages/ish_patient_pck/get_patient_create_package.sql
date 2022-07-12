-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


/*-----------------------------------------------------------------------------------------------------------------------------------------------------------------
'PatientCreate'
*/



CREATE OR REPLACE FUNCTION ish_patient_pck.get_patient_create ( nr_seq_fila_p bigint) RETURNS SETOF T_PATIENT_CREATE AS $body$
DECLARE


r_patient_create_w	r_patient_create;

nr_seq_documento_w	intpd_fila_transmissao.nr_seq_documento%type;
ie_conversao_w		intpd_eventos_sistema.ie_conversao%type;
nr_seq_regra_w		intpd_eventos_sistema.nr_seq_regra_conv%type;
cd_estab_doc intpd_fila_transmissao.cd_estab_documento%type;

cd_estabelecimento_w		estabelecimento.cd_estabelecimento%type;
cd_empresa_w			estabelecimento.cd_empresa%type;
reg_integracao_w		gerar_int_padrao.reg_integracao_conv;
cd_pessoa_fisica_w		pessoa_fisica.cd_pessoa_fisica%type;
cd_pessoa_fisica_externo_w	pf_codigo_externo.cd_pessoa_fisica_externo%type;


BEGIN
/*retorna vazio pois e envio de novo registro para o is-h, ou seja, ainda nao temos codigo do is-h para enviar*/


intpd_reg_integracao_inicio(nr_seq_fila_p, 'E', reg_integracao_w);

select	a.nr_seq_documento,
	coalesce(b.ie_conversao,'I'),
	b.nr_seq_regra_conv,
  a.cd_estab_documento
into STRICT	nr_seq_documento_w,
	ie_conversao_w,
	nr_seq_regra_w,
  cd_estab_doc
from	intpd_fila_transmissao a,
	intpd_eventos_sistema b
where	a.nr_seq_evento_sistema = b.nr_sequencia
and	a.nr_sequencia = nr_seq_fila_p;

cd_estabelecimento_w	:=	ish_patient_pck.get_patient_establishment(nr_seq_documento_w, cd_estab_doc);

select	cd_empresa
into STRICT	cd_empresa_w
from	estabelecimento
where	cd_estabelecimento = cd_estabelecimento_w;

reg_integracao_w.nm_tabela	:= 'ESTABELECIMENTO';
reg_integracao_w.nm_elemento	:= 'PatientCreate';

intpd_processar_atrib_envio(reg_integracao_w, 'CD_EMPRESA', 'client', 'N', cd_empresa_w, 'S', r_patient_create_w.client);
intpd_processar_atrib_envio(reg_integracao_w, 'CD_ESTABELECIMENTO', 'institution', 'N', cd_estabelecimento_w, 'S', r_patient_create_w.institution);

begin
select	cd_pessoa_fisica_externo
into STRICT	cd_pessoa_fisica_externo_w
from	pf_codigo_externo
where	cd_pessoa_fisica = nr_seq_documento_w
and	ie_tipo_codigo_externo = 'ISH'  LIMIT 1;
exception
when others then
	cd_pessoa_fisica_externo_w	:= null;
end;

if (cd_pessoa_fisica_externo_w IS NOT NULL AND cd_pessoa_fisica_externo_w::text <> '') then
	reg_integracao_w.nm_tabela	:= 'PF_CODIGO_EXTERNO';
	intpd_processar_atrib_envio(reg_integracao_w, 'CD_PESSOA_FISICA_EXTERNO', 'patientid', 'N', cd_pessoa_fisica_externo_w, 'N', r_patient_create_w.patientid);
	r_patient_create_w.transactmode	:=	'S';
else
	r_patient_create_w.transactmode	:=	'N';
end if;

CALL intpd_gravar_log_fila(reg_integracao_w);

--	testrun


RETURN NEXT r_patient_create_w;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION ish_patient_pck.get_patient_create ( nr_seq_fila_p bigint) FROM PUBLIC;