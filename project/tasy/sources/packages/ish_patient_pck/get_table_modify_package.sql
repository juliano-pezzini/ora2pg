-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION ish_patient_pck.get_table_modify ( nr_seq_fila_p bigint) RETURNS SETOF T_TABLE_MODIFY AS $body$
DECLARE


r_table_Modify_w	r_table_Modify;

nr_seq_documento_w	intpd_fila_transmissao.nr_seq_documento%type;
ie_operacao_w		intpd_fila_transmissao.ie_operacao%type;
ie_envio_recebe_w	intpd_fila_transmissao.ie_envio_recebe%type;
cd_estabelecimento_w	estabelecimento.cd_estabelecimento%type;
cd_empresa_w		estabelecimento.cd_empresa%type;
cd_pessoa_fisica_w	pessoa_classif.cd_pessoa_fisica%type;
nr_seq_classif_conv_w	varchar(255);

client_w		varchar(3);
institution_w		varchar(4);
patientid_w		varchar(10);
ivsign_w		varchar(1);
IsValue_w		varchar(4000);

reg_integracao_w		gerar_int_padrao.reg_integracao_conv;
pessoa_classif_w	pessoa_classif%rowtype;


BEGIN
begin
select	a.nr_seq_documento,
	CASE WHEN a.ie_envio_recebe='E' THEN  CASE WHEN a.ie_operacao='A' THEN  'U' WHEN a.ie_operacao='E' THEN  'D'  ELSE 'I' END   ELSE 'R' END ,
	ie_operacao,
	a.ie_envio_recebe
into STRICT	nr_seq_documento_w,
	ivsign_w,
	ie_operacao_w,
	ie_envio_recebe_w
from	intpd_fila_transmissao a,
	intpd_eventos_sistema b
where	a.nr_seq_evento_sistema = b.nr_sequencia
and	a.nr_sequencia = nr_seq_fila_p;
exception
when others then
	nr_seq_documento_w	:=	null;
end;

if (somente_numero(nr_seq_documento_w) > 0) then
	begin
	intpd_reg_integracao_inicio(nr_seq_fila_p, 'E', reg_integracao_w);
	reg_integracao_w.nm_tabela	:= 'PESSOA_CLASSIF';
	reg_integracao_w.nm_elemento	:= '_-rzvish_-tableModify';
	
	if (ie_envio_recebe_w = 'C') then
		begin
		select	client,
			institution,
			patientid
		into STRICT	client_w,
			institution_w,
			patientid_w
		from	table(ish_patient_pck.get_detail_request(nr_seq_fila_p));
		
		IsValue_w	:=	client_w || ';' || institution_w || ';' || patientid_w || ';';
		end;
	else
		begin	
		pessoa_classif_w.nr_sequencia		:=	obter_valor_campo_separador(nr_seq_documento_w, 1, '|');
		pessoa_classif_w.cd_pessoa_fisica	:=	obter_valor_campo_separador(nr_seq_documento_w, 2, '|');

		reg_integracao_w.ie_somente_alterados	:= 'N';

		if (ie_operacao_w in ('I', 'A')) then
			begin
			begin
			select	*
			into STRICT	pessoa_classif_w
			from	pessoa_classif
			where	nr_sequencia = pessoa_classif_w.nr_sequencia;
			exception
			when others then
				pessoa_classif_w.nr_sequencia	:=	null;
			end;
			end;
		end if;
		
		cd_estabelecimento_w	:=	obter_estabelecimento_ativo;
		
		select	cd_empresa
		into STRICT	cd_empresa_w
		from	estabelecimento
		where	cd_estabelecimento = cd_estabelecimento_w;
		
		begin
		select	cd_pessoa_fisica_externo
		into STRICT	patientid_w
		from	pf_codigo_externo
		where	cd_pessoa_fisica = pessoa_classif_w.cd_pessoa_fisica
		and	ie_tipo_codigo_externo = 'ISH'  LIMIT 1;
		exception
		when others then
			patientid_w	:=	null;
		end;	
		
		if (coalesce(patientid_w, 'NULL') = 'NULL') then
			IsValue_w	:=	null;
		else
			begin		
			if (reg_integracao_w.ie_envio_recebe = 'E') then
				if (coalesce(pessoa_classif_w.nr_sequencia, 0) <> 0) then
					intpd_processar_atrib_envio(reg_integracao_w, 'NR_SEQ_CLASSIF', 'NR_SEQ_CLASSIF', 'N', pessoa_classif_w.nr_seq_classif, 'S', nr_seq_classif_conv_w);
				end if;
				
				if (coalesce(nr_seq_classif_conv_w,'NULL') = 'NULL') then
					IsValue_w	:=	null;
				else
					begin
					if (nr_seq_classif_conv_w = 'DEFAULT') then
						nr_seq_classif_conv_w := null;
					end if;

					IsValue_w	:=	nr_seq_classif_conv_w || ';';

					if (coalesce(pessoa_classif_w.ds_observacao, 'NULL') <> 'NULL') then
						IsValue_w	:=	IsValue_w || pessoa_classif_w.ds_observacao || ';';
					end if;
					end;
				end if;
			end if;		
			
			reg_integracao_w.nm_tabela	:= 'ESTABELECIMENTO';
			intpd_processar_atrib_envio(reg_integracao_w, 'CD_EMPRESA', 'CD_EMPRESA', 'N', cd_empresa_w, 'S', client_w);
			intpd_processar_atrib_envio(reg_integracao_w, 'CD_ESTABELECIMENTO', 'CD_ESTABELECIMENTO', 'N', cd_estabelecimento_w, 'S', institution_w);
			
			IsValue_w	:=	client_w || ';' || institution_w || ';' || patientid_w || ';' || IsValue_w;
			end;
		end if;
		end;
	end if;

	reg_integracao_w.nm_tabela	:= 'PESSOA_CLASSIF';
	intpd_processar_atrib_envio(reg_integracao_w, 'ItName', 'ItName', 'N', 'ZNV2K_DN_PAT', 'N', r_table_Modify_w.itname);
	intpd_processar_atrib_envio(reg_integracao_w, 'IvSign', 'IvSign', 'N', ivsign_w, 'N', r_table_Modify_w.ivsign);	
	intpd_processar_atrib_envio(reg_integracao_w, 'IsValue', 'IsValue', 'N', IsValue_w, 'N', r_table_Modify_w.IsValue);

	RETURN NEXT r_table_Modify_w;
	end;
end if;

CALL intpd_gravar_log_fila(reg_integracao_w);
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION ish_patient_pck.get_table_modify ( nr_seq_fila_p bigint) FROM PUBLIC;