-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION ish_treatment_certificate_pck.get_treat_certificate_create (nr_seq_fila_p bigint) RETURNS SETOF T_TREAT_CERTIFICATE AS $body$
DECLARE

	
nr_seq_documento_w		intpd_fila_transmissao.nr_seq_documento%type;
ie_conversao_w			intpd_eventos_sistema.ie_conversao%type;
nr_seq_regra_w			intpd_eventos_sistema.nr_seq_regra_conv%type;	

r_treat_certificate_w		r_treat_certificate;
reg_integracao_w		gerar_int_padrao.reg_integracao_conv;

cd_estab_w			estabelecimento.cd_estabelecimento%type;
cd_empresa_w			estabelecimento.cd_empresa%type;
nr_episodio_w			episodio_paciente.nr_episodio%type;
cd_pessoa_fisica_w		pessoa_fisica.cd_pessoa_fisica%type;
nr_seq_tipo_admissao_fat_w	atendimento_paciente.nr_seq_tipo_admissao_fat%type;
nr_atendimento_w		atendimento_paciente.nr_atendimento%type;
movemnttype_w			varchar(255);
dt_entrada_w			timestamp;

			
c01 CURSOR FOR
SELECT	*
from	atendimento_paciente_inf a
where	a.nr_sequencia	= 
	(select max(x.nr_sequencia)
	from	atendimento_paciente_inf x
	where	x.nr_atendimento = nr_seq_documento_w);

c01_w	c01%rowtype;
	

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

begin
select	b.nr_atendimento,
	a.cd_empresa,
	a.cd_estabelecimento,
	c.nr_episodio,
	b.cd_pessoa_fisica,
	b.nr_seq_tipo_admissao_fat,
	b.dt_entrada
into STRICT	nr_atendimento_w,
	cd_empresa_w,
	cd_estab_w,
	nr_episodio_w,
	cd_pessoa_fisica_w,
	nr_seq_tipo_admissao_fat_w,
	dt_entrada_w
FROM estabelecimento a, atendimento_paciente b
LEFT OUTER JOIN episodio_paciente c ON (b.nr_seq_episodio = c.nr_sequencia)
WHERE b.cd_estabelecimento 	= a.cd_estabelecimento and b.nr_atendimento	= nr_seq_documento_w;
exception
when others then
	null;
end;

reg_integracao_w.nm_tabela 	:= 'ESTABELECIMENTO';
reg_integracao_w.nm_elemento	:= '_-rzvish_-certificTreatmCreate';

intpd_processar_atrib_envio(reg_integracao_w, 'CD_EMPRESA', 'client', 'N', cd_empresa_w, 'S', r_treat_certificate_w.client);
intpd_processar_atrib_envio(reg_integracao_w, 'CD_ESTABELECIMENTO', 'institution', 'N', cd_estab_w, 'S', r_treat_certificate_w.institution);

reg_integracao_w.nm_tabela 	:= 'EPISODIO_PACIENTE';
intpd_processar_atrib_envio(reg_integracao_w, 'NR_EPISODIO', 'patcaseid', 'N', nr_episodio_w, 'N', r_treat_certificate_w.patcaseid);

open C01;
loop
fetch C01 into
	c01_w;
EXIT WHEN NOT FOUND; /* apply on C01 */

	reg_integracao_w.nm_tabela 	:= 'ATENDIMENTO_PACIENTE';
	intpd_processar_atrib_envio(reg_integracao_w, 'KSTYP_TIPO_ADMISSAO_FAT', 'Kstyp', 'N', nr_seq_tipo_admissao_fat_w, 'S', movemnttype_w);
	r_treat_certificate_w.Kstyp	:= obter_valor_campo_separador(movemnttype_w, 1, ish_param_pck.get_separador);
	r_treat_certificate_w.Ksart	:= obter_valor_campo_separador(movemnttype_w, 2, ish_param_pck.get_separador);
	
	r_treat_certificate_w.Begdt	:= to_char(ish_treatment_certificate_pck.obter_data_quarter(dt_entrada_w,'I'),'yyyy-mm-dd');	
	r_treat_certificate_w.Enddt	:= to_char(ish_treatment_certificate_pck.obter_data_quarter(dt_entrada_w,'F'),'yyyy-mm-dd');	
	r_treat_certificate_w.Uadat	:= to_char(coalesce(c01_w.DT_REFERENCIA ,dt_entrada_w),'yyyy-mm-dd');
		
	begin
	select	a.cd_cgc
	into STRICT	r_treat_certificate_w.kostr
	from	convenio a,
		atend_categoria_convenio b
	where	a.cd_convenio		= b.cd_convenio
	and	b.nr_atendimento	= nr_atendimento_w
	and	b.nr_seq_interno	=
			(SELECT	min(x.nr_seq_interno)
			from	atend_categoria_convenio x
			where	x.nr_atendimento	= nr_atendimento_w)  LIMIT 1;
	exception
	when others then
		r_treat_certificate_w.kostr	:=	null;
	end;
	reg_integracao_w.nm_tabela 		:= 'ATEND_CATEGORIA_CONVENIO';	
	intpd_processar_atrib_envio(reg_integracao_w, 'CD_CONVENIO', 'Kostr', 'N', r_treat_certificate_w.Kostr, 'N', r_treat_certificate_w.Kostr);
	
	reg_integracao_w.nm_tabela 		:= 'ATENDIMENTO_PACIENTE_INF';
	intpd_processar_atrib_envio(reg_integracao_w, 'IE_EXISTE', 'Behst', 'N', c01_w.ie_existe, 'S', r_treat_certificate_w.Behst);
end loop;
close C01;

RETURN NEXT r_treat_certificate_w;
CALL intpd_gravar_log_fila(reg_integracao_w);

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION ish_treatment_certificate_pck.get_treat_certificate_create (nr_seq_fila_p bigint) FROM PUBLIC;
