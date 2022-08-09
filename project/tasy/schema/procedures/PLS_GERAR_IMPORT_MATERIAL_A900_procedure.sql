-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gerar_import_material_a900 ( nr_seq_lote_imp_p bigint, nm_arquivo_p text, nm_usuario_p text, ds_erro_p INOUT text) AS $body$
DECLARE

				
/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: Inserir os materiais na W_PLS_MATERIAL_UNIMED
-------------------------------------------------------------------------------------------------------------------

Locais de chamada direta: 
[  ]  Objetos do dicionário [X] Tasy (Delphi/Java) [  ] Portal [  ]  Relatórios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------

Pontos de atenção: 		FEITO POR LOTE
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/ 

ds_local_w			varchar(255);
ds_erro_w			varchar(255);
ie_leitura_w			boolean := true;
ds_linha_w			varchar(4000);
ie_tipo_w			varchar(3);
qt_registro_w			integer := 0;
nr_versao_ptu_w			pls_lote_imp_mat_unimed.nr_versao_ptu%type;
ie_tipo_arquivo_imp_w		pls_lote_imp_mat_unimed.ie_tipo_arquivo_imp%type;
ie_versao_w			bigint;
ie_tipo_pai_w			varchar(3);
qt_linha_filha_w		integer;
nr_seq_mat_unimed_w		w_pls_material_unimed.nr_sequencia%type;
nm_material_w			w_pls_material_unimed.nm_material%type;

procedure atualiza_estatistica(	nm_tabela_p	in text,
				nr_percentual_p	in bigint) is
;
BEGIN

CALL exec_sql_dinamico('Atz Estat PTU_MATERIAL', 'begin DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>''TASY'', TABNAME=>'''||nm_tabela_p||''', ESTIMATE_PERCENT=>'||nr_percentual_p||'); end;');

end;

begin
-- Limpar tabela temporaria
delete FROM w_pls_mat_unimed_trib;
commit;

delete FROM w_pls_mat_unimed_bras;
commit;

delete FROM w_pls_mat_unimed_simpro;
commit;

delete FROM w_pls_material_unimed;
commit;

-- Obter endereço 
SELECT * FROM obter_evento_utl_file(2, null, ds_local_w, ds_erro_w) INTO STRICT ds_local_w, ds_erro_w;

select	max(nr_versao_ptu),
	coalesce(max(ie_tipo_arquivo_imp),'M1')
into STRICT	nr_versao_ptu_w,
	ie_tipo_arquivo_imp_w
from	pls_lote_imp_mat_unimed
where	nr_sequencia = nr_seq_lote_imp_p;

if (ie_tipo_arquivo_imp_w = 'M1') then
	if (upper(nm_arquivo_p) like('%M2%')) or (upper(nm_arquivo_p) like('%M3%')) then
		ds_erro_w	:= wheb_mensagem_pck.get_texto(195168);
		goto finalErro;
	end if;

elsif (ie_tipo_arquivo_imp_w = 'M2') then
	if (upper(nm_arquivo_p) like('%M1%')) or (upper(nm_arquivo_p) like('%M3%')) then
		ds_erro_w	:= wheb_mensagem_pck.get_texto(291058);
		goto finalErro;
	end if;

elsif (ie_tipo_arquivo_imp_w = 'M3') then
	if (upper(nm_arquivo_p) like('%M1%')) or (upper(nm_arquivo_p) like('%M2%')) then
		ds_erro_w	:= wheb_mensagem_pck.get_texto(291059);
		goto finalErro;
	end if;

end if;

if (substr(ds_local_w,length(ds_local_w)-1,length(ds_local_w)) <> '\') then --'
	ds_local_w := ds_local_w || '\'; --'
end if;

-- Atualizar o lote de importação
update	pls_lote_imp_mat_unimed
set	dt_inicio_importacao	= sysdate,
	nm_arquivo		= ds_local_w || nm_arquivo_p
where 	nr_sequencia		= nr_seq_lote_imp_p;

-- Arquivo
pls_utl_file_pck.nova_leitura(2, nm_arquivo_p);

gravar_processo_longo('Importar materiais' ,'PLS_GERAR_IMPORT_MATERIAL_A900',0);

while (ie_leitura_w) loop
	-- Retorna linha do arquivo
	pls_utl_file_pck.ler(ds_linha_w, ie_leitura_w);
	
	ie_tipo_w	:= substr(ds_linha_w,9,3);
	qt_registro_w	:= qt_registro_w + 1;
	
	if	(nr_versao_ptu_w is not null) then
		-- PTU 4.0
		if	(ie_tipo_w = '901') and
			(nr_versao_ptu_w = '040') and
			(substr(ds_linha_w,25,2) <> '02') then
			ds_erro_w	:= wheb_mensagem_pck.get_texto(271229);
			goto finalErro;
		end if;	
		
		-- PTU 4.1
		if	(nr_versao_ptu_w = '041') and
			(((ie_tipo_w = '902') and (substr(ds_linha_w,282,8) is not null)) or
			((ie_tipo_w = '905') and (substr(ds_linha_w,128,8) is not null))) then
			ds_erro_w	:= wheb_mensagem_pck.get_texto(271229);
			goto finalErro;
		end if;
		
		-- PTU 5.0
		if	(nr_versao_ptu_w in ('050','060','061','062','063')) and
			(((ie_tipo_w = '902') and (substr(ds_linha_w,282,8) is null)) or
			((ie_tipo_w = '905') and (substr(ds_linha_w,128,8) is null))) then
			ds_erro_w	:= wheb_mensagem_pck.get_texto(271229);
			goto finalErro;
		end if;
	end if;
	
	if	(ie_tipo_w = '901') then
		ie_versao_w := to_number(substr(ds_linha_w,25,2));
	end if;
	
	if	(ie_versao_w <= 3) then -- PTU 5.0 ou menos	
		pls_gerar_import_material_v50(	ds_linha_w, ie_tipo_w, nr_seq_lote_imp_p, nm_arquivo_p, nm_usuario_p,
						nr_seq_mat_unimed_w, nm_material_w, ie_tipo_pai_w, qt_linha_filha_w, ds_erro_p);
	
	elsif	(ie_versao_w = 4) then -- PTU 6.2
		pls_gerar_import_material_v62(	ds_linha_w, ie_tipo_w, nr_seq_lote_imp_p, nm_arquivo_p, nm_usuario_p,
						nr_seq_mat_unimed_w, nm_material_w, ie_tipo_pai_w, qt_linha_filha_w, ds_erro_p);

	elsif	(ie_versao_w = 5) then -- PTU 6.3
		pls_gerar_import_material_v63(	ds_linha_w, ie_tipo_w, nr_seq_lote_imp_p, nm_arquivo_p, nm_usuario_p,
						nr_seq_mat_unimed_w, nm_material_w, ie_tipo_pai_w, qt_linha_filha_w, ds_erro_p);
						
	elsif	(ie_versao_w = 6) then -- PTU 7.0
		pls_gerar_import_material_v70(	ds_linha_w, ie_tipo_w, nr_seq_lote_imp_p, nm_arquivo_p, nm_usuario_p,
						nr_seq_mat_unimed_w, nm_material_w, ie_tipo_pai_w, qt_linha_filha_w, ds_erro_p);
						
	elsif	(ie_versao_w = 7) then -- PTU 9.0
		pls_gerar_import_material_v90(	ds_linha_w, ie_tipo_w, nr_seq_lote_imp_p, nm_arquivo_p, nm_usuario_p,
						nr_seq_mat_unimed_w, nm_material_w, ie_tipo_pai_w, qt_linha_filha_w, ds_erro_p);
	elsif	(ie_versao_w = 8) then -- PTU 10a
		pls_gerar_import_mat_v10a(	ds_linha_w, ie_tipo_w, nr_seq_lote_imp_p, nm_arquivo_p, nm_usuario_p,
						nr_seq_mat_unimed_w, nm_material_w, ie_tipo_pai_w, qt_linha_filha_w, ds_erro_p);
	end if;
	
	if	(qt_registro_w = 10000) then
		commit;
		qt_registro_w	:= 0;
	end if;	
end loop;
pls_utl_file_pck.fechar_arquivo;

-- Como a tabela é temporária e possui indice, tem que atualizar 
atualiza_estatistica('W_PLS_MATERIAL_UNIMED',100);
atualiza_estatistica('W_PLS_MAT_UNIMED_TRIB',100);
atualiza_estatistica('W_PLS_MAT_UNIMED_BRAS',100);
atualiza_estatistica('W_PLS_MAT_UNIMED_SIMPRO',100);

-- Atualizar o lote de importação
update	pls_lote_imp_mat_unimed
set	dt_fim_importacao	= clock_timestamp(),
	nm_usuario_imp		= nm_usuario_p,
	ie_tipo_arquivo_imp	= ie_tipo_arquivo_imp_w
where 	nr_sequencia		= nr_seq_lote_imp_p;

commit;

<<finalErro>>
ds_erro_p	:= ds_erro_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_import_material_a900 ( nr_seq_lote_imp_p bigint, nm_arquivo_p text, nm_usuario_p text, ds_erro_p INOUT text) FROM PUBLIC;
