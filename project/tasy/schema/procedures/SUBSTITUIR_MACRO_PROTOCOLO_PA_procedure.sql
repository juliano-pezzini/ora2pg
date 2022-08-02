-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE substituir_macro_protocolo_pa ( nr_seq_chave_p bigint, ds_texto_p text, nr_atendimento_p bigint, nm_usuario_p text, ie_opcao_p text, nr_cirurgia_p bigint default null) AS $body$
DECLARE

/*	ie_opcao_p
A - Anamnese
E - Evolucao
R - Receitas
*/
ds_retorno_w		text;
ds_texto_w		varchar(32764);
ds_texto_alterado_w	varchar(32764);
pos_macro_w		bigint;
ds_macro_w		varchar(50);
ds_macro_cliente_w		varchar(255);
nm_atributo_w		varchar(50);
pos_fim_macro_w		bigint;
vl_atributo_w		varchar(255);
ds_resultado_macro_w	varchar(255);
cd_pessoa_fisica_w	varchar(14);


BEGIN

ds_texto_w	:= ds_texto_p;
ds_texto_alterado_w	:= ds_texto_w;

select	cd_pessoa_fisica
into STRICT	cd_pessoa_fisica_w
from	atendimento_paciente
where	nr_atendimento	= nr_atendimento_p;

if (ds_texto_w IS NOT NULL AND ds_texto_w::text <> '') then
	WHILE(ds_texto_w IS NOT NULL AND ds_texto_w::text <> '') LOOP
		begin

		pos_macro_w	:= position('@' in ds_texto_w);
		
		if (pos_macro_w > 0) then

			ds_macro_w	:= Elimina_Caracteres_Especiais(regexp_substr(ds_texto_w, '@[A-Za-z0-9_]*'));
			
			if ((coalesce(ds_macro_w,null) IS NOT NULL AND (coalesce(ds_macro_w,null))::text <> '')) then
				begin
				select	max(m.nm_macro)
				into STRICT	ds_macro_cliente_w
				from	macro_prontuario m,
					funcao_macro_cliente c,
					funcao_macro f
				where	f.cd_funcao = 6001
				and	f.nr_sequencia = c.nr_seq_macro
				and	c.ds_macro = ds_macro_w
				and	m.nm_macro = f.ds_macro;

				select	max(nm_atributo)
				into STRICT	nm_atributo_w
				from	macro_prontuario
				where	upper(nm_macro) = upper(coalesce(ds_macro_cliente_w,ds_macro_w));
				exception
				when others then
					nm_atributo_w := null;
				end;
				
				if ((coalesce(nm_atributo_w,null) IS NOT NULL AND (coalesce(nm_atributo_w,null))::text <> '')) then
					if (upper(nm_atributo_w) = 'CD_PESSOA_FISICA') then
						vl_atributo_w	:= cd_pessoa_fisica_w;
					elsif (upper(nm_atributo_w) = 'NR_ATENDIMENTO') then
						vl_atributo_w	:= to_char(nr_atendimento_p);
					elsif (upper(nm_atributo_w) = 'CD_PESSOA_USUARIO') then
						select	Obter_Pessoa_Fisica_Usuario(nm_usuario_p, 'C')
						into STRICT	vl_atributo_w
						;
					elsif (upper(nm_atributo_w) = 'NR_CIRURGIA') then
						vl_atributo_w	:= nr_cirurgia_p;
					end if;
					
					ds_resultado_macro_w	:= Substituir_Macro_Texto_Tasy(upper(coalesce(ds_macro_cliente_w,ds_macro_w)), nm_atributo_w, vl_atributo_w);
					
					ds_texto_alterado_w	:=  replace(ds_texto_alterado_w, ds_macro_w, ds_resultado_macro_w);

				end if;
			end if;
			
			
			ds_texto_w	:= substr(ds_texto_w,pos_macro_w + length(coalesce(ds_macro_w, ' ')), length(ds_texto_w));
		else
			ds_texto_w := '';
		end if;
		
		end;
	END loop;
	
	if (ie_opcao_p = 'A') then
		update	anamnese_paciente
		set	ds_anamnese	= ds_texto_alterado_w
		where	nr_sequencia	= nr_seq_chave_p;
	elsif (ie_opcao_p = 'E') then
		update	evolucao_paciente
		set	ds_evolucao	= ds_texto_alterado_w
		where	cd_evolucao	= nr_seq_chave_p;
	elsif (ie_opcao_p = 'R') then
		update	med_receita
		set	ds_receita	= ds_texto_alterado_w
		where	nr_sequencia	= nr_seq_chave_p;
		
	elsif (ie_opcao_p = 'AT') then
		update	ATESTADO_PACIENTE
		set	DS_ATESTADO	= ds_texto_alterado_w
		where	nr_sequencia	= nr_seq_chave_p;
		
	elsif (ie_opcao_p = 'JU') then
		update	PACIENTE_JUSTIFICATIVA
		set	DS_JUSTIFICATIVA	= ds_texto_alterado_w
		where	nr_sequencia	= nr_seq_chave_p;
		
	elsif (ie_opcao_p = 'OA') then
		update	ATENDIMENTO_ALTA
		set	DS_ORIENTACAO	= ds_texto_alterado_w
		where	nr_sequencia	= nr_seq_chave_p;
	elsif (ie_opcao_p = 'OG') then
		update	PEP_ORIENTACAO_GERAL
		set	DS_ORIENTACAO_GERAL	= ds_texto_alterado_w
		where	nr_sequencia	= nr_seq_chave_p;
	elsif (ie_opcao_p = 'CI') then
		update	pep_pac_ci
		set	ds_texto	= ds_texto_alterado_w
		where	nr_sequencia	= nr_seq_chave_p;
	elsif (ie_opcao_p = 'DC') then
		update	CIRURGIA_DESCRICAO
		set		DS_CIRURGIA= ds_texto_alterado_w
		where	nr_sequencia	= nr_seq_chave_p;
	elsif (ie_opcao_p = 'HP') then
		update	HEM_PROC
		set		DS_LAUDO= ds_texto_alterado_w
		where	nr_sequencia	= nr_seq_chave_p;
	end if;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE substituir_macro_protocolo_pa ( nr_seq_chave_p bigint, ds_texto_p text, nr_atendimento_p bigint, nm_usuario_p text, ie_opcao_p text, nr_cirurgia_p bigint default null) FROM PUBLIC;

