-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE insert_ontology_configuration ( nr_sequencia_p bigint, nm_usuario_p text) AS $body$
DECLARE



nm_tabela_w				res_cadastro_ontologia_phi.nm_tabela%type;
nm_atributo_w			res_cadastro_ontologia_phi.nm_atributo%type;
ie_exists_ontology_w	smallint;
ie_exists_atrib_ont_w	smallint;
nr_seq_visao_w			res_cadastro_ontologia_phi.nr_seq_visao%type;
cd_exp_label_w			tabela_visao_atributo.cd_exp_label%type;
cd_exp_label_longo_w	tabela_visao_atributo.cd_exp_label_longo%type;
cd_exp_valores_w		tabela_visao_atributo.cd_exp_valores%type;
cd_dominio_w			tabela_visao_atributo.cd_dominio%type;
nr_seq_dic_objeto_w		tabela_visao_atributo.nr_seq_dic_objeto%type;
nr_seq_localizador_w	tabela_visao_atributo.nr_seq_localizador%type;
cd_exp_cadastro_w		tabela_sistema.cd_exp_cadastro%type;



BEGIN

select  max(nm_tabela),
		    max(nm_atributo),
		    max(nr_seq_visao)
into STRICT 	  nm_tabela_w,
		    nm_atributo_w,
		    nr_seq_visao_w
from 	  res_cadastro_ontologia_phi
where 	nr_sequencia = nr_sequencia_p;


select  max(cd_exp_label),
        max(cd_exp_label_longo),
		    max(cd_exp_valores),
		    max(cd_dominio),
		    max(nr_seq_dic_objeto),
		    max(nr_seq_localizador)
into STRICT    cd_exp_label_w,
		    cd_exp_label_longo_w,
		    cd_exp_valores_w,
		    cd_dominio_w,
		    nr_seq_dic_objeto_w,
		    nr_seq_localizador_w
from  	TABELA_VISAO_ATRIBUTO
where 	nr_sequencia  = nr_seq_visao_w
and     nm_atributo   = nm_atributo_w;

select  count(*)
into STRICT    ie_exists_ontology_w
from    ontologia_tabela
where   nm_tabela = nm_tabela_w;

select  count(*)
into STRICT    ie_exists_atrib_ont_w
from    ontologia_tabela_atributo
where   nm_tabela 	= nm_tabela_w
and     nm_atributo = nm_atributo_w;



if (ie_exists_ontology_w = 0) then
	begin
	
		select	max(cd_exp_cadastro)
		into STRICT	cd_exp_cadastro_w
		from	tabela_sistema
		where	nm_tabela = nm_tabela_w;
		
		insert into ontologia_tabela(
						nr_sequencia,
						dt_atualizacao,
						nm_usuario,
						dt_atualizacao_nrec,
						nm_usuario_nrec,
						nm_tabela,
						cd_exp_cadastro,
						ie_cadastro,
						ie_grupo,
						ie_situacao)
		values (		nextval('ontologia_tabela_seq'),
						clock_timestamp(),
						nm_usuario_p,
						clock_timestamp(),
						nm_usuario_p,
						nm_tabela_w,
						cd_exp_cadastro_w,
						'N',
						null,
						'A');
						
		if (ie_exists_atrib_ont_w = 0) then
			begin
				
				insert into ontologia_tabela_atributo(
								nr_sequencia,
								dt_atualizacao,
								nm_usuario,
								dt_atualizacao_nrec,
								nm_usuario_nrec,
								nm_tabela,
								nm_atributo,
								cd_exp_desc,
								cd_exp_label_longo,
								cd_exp_valores,
								cd_dominio,
								cd_condicao,
								ie_filtro,
								cd_valor_default,
								ie_visible,
								nr_seq_dic_objeto,
								nr_seq_localizador)
				values (		nextval('ontologia_tabela_atributo_seq'),
								clock_timestamp(),
								nm_usuario_p,
								clock_timestamp(),
								nm_usuario_p,
								nm_tabela_w,
								nm_atributo_w,
								cd_exp_label_w,
								null,
								cd_exp_valores_w,
								cd_dominio_w,
								null,
								null,
								null,
								null,
								nr_seq_dic_objeto_w,
								nr_seq_localizador_w);
				
				
			end;
		end if;		
		
	end;
elsif (ie_exists_ontology_w > 0 and ie_exists_atrib_ont_w = 0) then
	begin
		
		
		insert into ontologia_tabela_atributo(
								nr_sequencia,
								dt_atualizacao,
								nm_usuario,
								dt_atualizacao_nrec,
								nm_usuario_nrec,
								nm_tabela,
								nm_atributo,
								cd_exp_desc,
								cd_exp_label_longo,
								cd_exp_valores,
								cd_dominio,
								cd_condicao,
								ie_filtro,
								cd_valor_default,
								ie_visible,
								nr_seq_dic_objeto,
								nr_seq_localizador)
		values (		nextval('ontologia_tabela_atributo_seq'),
								clock_timestamp(),
								nm_usuario_p,
								clock_timestamp(),
								nm_usuario_p,
								nm_tabela_w,
								nm_atributo_w,
								cd_exp_label_w,
								null,
								cd_exp_valores_w,
								cd_dominio_w,
								null,
								null,
								null,
								null,
								nr_seq_dic_objeto_w,
								nr_seq_localizador_w);
								
	
	end;
elsif (ie_exists_ontology_w > 0 and ie_exists_atrib_ont_w > 0) then
	begin
		CALL wheb_mensagem_pck.exibir_mensagem_abort(1136119);
	end;
end if;

commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE insert_ontology_configuration ( nr_sequencia_p bigint, nm_usuario_p text) FROM PUBLIC;

