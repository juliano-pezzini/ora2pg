-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE carregar_colunas_grid_wcpanel ( cd_funcao_p bigint, nm_componente_p text, ie_tipo_p text, nr_seq_objeto_p bigint default null, nm_coluna_p text default null, ds_titulo_coluna_p text default null, nr_seq_visao_p bigint default null, nm_tabela_p text default null, nm_usuario_p text DEFAULT NULL) AS $body$
DECLARE


nm_campo_base_w		varchar(100);
ds_titulo_w			varchar(200);
ie_tipo_coluna_w	varchar(2);
nr_sequencia_w		bigint;
ie_atalho_w			varchar(15);
nm_componente_w		varchar(100);

CWCPanel1 CURSOR FOR
SELECT	substr(nm_campo_base,1,100),
		substr(coalesce(obter_desc_expressao(cd_exp_campo_tela), nm_campo_tela),1,200)
from	dic_objeto
where	nr_seq_obj_sup	= nr_seq_objeto_p
and		ie_tipo_objeto = 'AC';

CWPUMC CURSOR FOR
SELECT	nr_sequencia,
		substr(nm_objeto,1,100),
		substr(coalesce(obter_desc_expressao(cd_exp_texto), ds_texto),1,200),
		ie_atalho,
		substr(obter_nome_obj_dic_obj(nr_seq_obj_sup),1,100)
from	dic_objeto
where	nr_seq_obj_sup	= nr_seq_objeto_p
and		ie_tipo_objeto = 'MI';

CWDBPanelVisao CURSOR FOR
SELECT	substr(nm_atributo,1,100),
        substr(coalesce(obter_desc_expressao(cd_exp_label), ds_label),1,200),
        'GD' tipo
from	tabela_visao_atributo
where	nr_sequencia	= nr_seq_visao_p
and	  	(nr_seq_apresent IS NOT NULL AND nr_seq_apresent::text <> '')
and     ((cd_exp_label IS NOT NULL AND cd_exp_label::text <> '') or (coalesce(ds_label,'') <> ''))
and     ((cd_exp_label_grid IS NOT NULL AND cd_exp_label_grid::text <> '') or (coalesce(ds_label_grid,'') <> ''))

union

select	substr(nm_atributo,1,100),
        substr(coalesce(obter_desc_expressao(cd_exp_label), ds_label),1,200),
        'D' tipo
from	tabela_visao_atributo
where	nr_sequencia	= nr_seq_visao_p
and	  	(nr_seq_apresent IS NOT NULL AND nr_seq_apresent::text <> '')
and     ((cd_exp_label IS NOT NULL AND cd_exp_label::text <> '') or (coalesce(ds_label,'') <> ''))
and     coalesce(cd_exp_label_grid::text, '') = ''
and     coalesce(trim(both ds_label_grid)::text, '') = ''

union

select	substr(nm_atributo,1,100),
        substr(coalesce(obter_desc_expressao(cd_exp_label_grid), ds_label_grid),1,200),
        'G' tipo
from	tabela_visao_atributo
where	nr_sequencia	= nr_seq_visao_p
and	  	(nr_seq_apresent IS NOT NULL AND nr_seq_apresent::text <> '')
and     ((cd_exp_label_grid IS NOT NULL AND cd_exp_label_grid::text <> '') or (coalesce(ds_label_grid,'') <> ''))
and     coalesce(cd_exp_label::text, '') = ''
and     coalesce(trim(both ds_label)::text, '') = '';

CWDBPanelTabela CURSOR FOR
SELECT	substr(nm_atributo,1,100),
        substr(coalesce(obter_desc_expressao(cd_exp_label), ds_label),1,200),
        'GD' tipo
from	tabela_atributo
where	  nm_tabela	= nm_tabela_p
and	  	(nr_seq_apresent IS NOT NULL AND nr_seq_apresent::text <> '')
and     ((cd_exp_label IS NOT NULL AND cd_exp_label::text <> '') or (coalesce(ds_label,'') <> ''))
and     ((cd_exp_label_grid IS NOT NULL AND cd_exp_label_grid::text <> '') or (coalesce(ds_label_grid,'') <> ''))

union

select	substr(nm_atributo,1,100),
        substr(coalesce(obter_desc_expressao(cd_exp_label), ds_label),1,200),
        'D' tipo
from	tabela_atributo
where	  nm_tabela	= nm_tabela_p
and	  	(nr_seq_apresent IS NOT NULL AND nr_seq_apresent::text <> '')
and     ((cd_exp_label IS NOT NULL AND cd_exp_label::text <> '') or (coalesce(ds_label,'') <> ''))
and     coalesce(cd_exp_label_grid::text, '') = ''
and     coalesce(trim(both ds_label_grid)::text, '') = ''

union

select	substr(nm_atributo,1,100),
        substr(coalesce(obter_desc_expressao(cd_exp_label_grid), ds_label_grid),1,200),
        'G' tipo
from	tabela_atributo
where	nm_tabela	= nm_tabela_p
and	  	(nr_seq_apresent IS NOT NULL AND nr_seq_apresent::text <> '')
and     ((cd_exp_label_grid IS NOT NULL AND cd_exp_label_grid::text <> '') or (coalesce(ds_label_grid,'') <> ''))
and     coalesce(cd_exp_label::text, '') = ''
and     coalesce(trim(both ds_label)::text, '') = '';


BEGIN
if (cd_funcao_p IS NOT NULL AND cd_funcao_p::text <> '') and (nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '') and (ie_tipo_p IS NOT NULL AND ie_tipo_p::text <> '') then
	begin

	if (ie_tipo_p = 'P') then--WCPanel
		begin
		if (coalesce(nr_seq_objeto_p,0) > 0) then
			begin
			open CWCPanel1;
			loop
			fetch CWCPanel1 into
				nm_campo_base_w,
				ds_titulo_w;
			EXIT WHEN NOT FOUND; /* apply on CWCPanel1 */
				begin
				insert into	w_colunas_grid_wcpanel(	nr_sequencia,
					dt_atualizacao,
					nm_usuario,
					dt_atualizacao_nrec,
					nm_usuario_nrec,
					cd_funcao,
					nm_coluna,
					ds_titulo_coluna,
					nm_componente,
					cd_codigo,
					nr_seq_objeto,
					nr_seq_visao,
					ie_tipo,
					nm_tabela,
					ie_tipo_coluna
				) values (
					nextval('w_colunas_grid_wcpanel_seq'),
					clock_timestamp(),
					nm_usuario_p,
					clock_timestamp(),
					nm_usuario_p,
					cd_funcao_p,
					nm_campo_base_w,
					ds_titulo_w,
					nm_componente_p,
					null,
					nr_seq_objeto_p,
					null,
					ie_tipo_p,
					null,
					null);
				end;
			end loop;
			close CWCPanel1;
			end;
		elsif (nm_coluna_p IS NOT NULL AND nm_coluna_p::text <> '') then
			begin
			insert into	w_colunas_grid_wcpanel(	nr_sequencia,
				dt_atualizacao,
				nm_usuario,
				dt_atualizacao_nrec,
				nm_usuario_nrec,
				cd_funcao,
				nm_coluna,
				ds_titulo_coluna,
				nm_componente,
				cd_codigo,
				nr_seq_objeto,
				nr_seq_visao,
				ie_tipo,
				nm_tabela,
				ie_tipo_coluna
			) values (
				nextval('w_colunas_grid_wcpanel_seq'),
				clock_timestamp(),
				nm_usuario_p,
				clock_timestamp(),
				nm_usuario_p,
				cd_funcao_p,
				nm_coluna_p,
				ds_titulo_coluna_p,
				nm_componente_p,
				null,
				null,
				null,
				ie_tipo_p,
				null,
				null);
			end;
		end if;
		end;
	elsif (ie_tipo_p = 'WJ') then -- WDLG Java
		begin
		insert into	w_colunas_grid_wcpanel(	nr_sequencia,
				dt_atualizacao,
				nm_usuario,
				dt_atualizacao_nrec,
				nm_usuario_nrec,
				cd_funcao,
				nm_coluna,
				ds_titulo_coluna,
				nm_componente,
				cd_codigo,
				nr_seq_objeto,
				nr_seq_visao,
				ie_tipo,
				nm_tabela,
				ie_tipo_coluna
			) values (
				nextval('w_colunas_grid_wcpanel_seq'),
				clock_timestamp(),
				nm_usuario_p,
				clock_timestamp(),
				nm_usuario_p,
				cd_funcao_p,
				'',
				'',
				nm_componente_p,
				null,
				null,
				null,
				ie_tipo_p,
				'',
				'');
		end;
	elsif (ie_tipo_p = 'MI') then --Menu item Delphi
		begin
		if (coalesce(nr_seq_objeto_p,0) > 0) then
			begin
			open CWPUMC;
			loop
			fetch CWPUMC into
				nr_sequencia_w,
				nm_campo_base_w,
				ds_titulo_w,
				ie_atalho_w,
				nm_componente_w;
			EXIT WHEN NOT FOUND; /* apply on CWPUMC */
				begin
				insert into	w_analise_migr_proj(	nr_sequencia,
					dt_atualizacao_nrec,
					nm_usuario_nrec,
					dt_atualizacao,
					nm_usuario,
					cd_funcao,
					nm_objeto,
					ds_objeto,
					ie_objeto,
					qt_tempo_desenv,
					ds_shortcut,
					nm_objeto_pai,
					nm_objeto_avo
				) values (
					nextval('w_analise_migr_proj_seq'),
					clock_timestamp(),
					nm_usuario_p,
					clock_timestamp(),
					nm_usuario_p,
					cd_funcao_p,
					nm_campo_base_w,
					ds_titulo_w,
					ie_tipo_p,
					60,
					ie_atalho_w,
					nm_componente_w,
					nr_sequencia_w);
				end;
			end loop;
			close CWPUMC;
			end;
		end if;
		end;
	elsif (ie_tipo_p = 'B') or (ie_tipo_p = 'BJ') then --WDBPanel
		begin
		if (coalesce(nr_seq_visao_p,0) > 0) then
			begin
			open CWDBPanelVisao;
			loop
			fetch CWDBPanelVisao into
				nm_campo_base_w,
				ds_titulo_w,
				ie_tipo_coluna_w;
			EXIT WHEN NOT FOUND; /* apply on CWDBPanelVisao */
				begin
				insert into	w_colunas_grid_wcpanel(	nr_sequencia,
					dt_atualizacao,
					nm_usuario,
					dt_atualizacao_nrec,
					nm_usuario_nrec,
					cd_funcao,
					nm_coluna,
					ds_titulo_coluna,
					nm_componente,
					cd_codigo,
					nr_seq_objeto,
					nr_seq_visao,
					ie_tipo,
					nm_tabela,
					ie_tipo_coluna
				) values (
					nextval('w_colunas_grid_wcpanel_seq'),
					clock_timestamp(),
					nm_usuario_p,
					clock_timestamp(),
					nm_usuario_p,
					cd_funcao_p,
					nm_campo_base_w,
					ds_titulo_w,
					nm_componente_p,
					null,
					null,
					nr_seq_visao_p,
					ie_tipo_p,
					nm_tabela_p,
					ie_tipo_coluna_w);
				end;
			end loop;
			close CWDBPanelVisao;
			end;
		elsif (nm_tabela_p IS NOT NULL AND nm_tabela_p::text <> '') then
			begin
			open CWDBPanelTabela;
			loop
			fetch CWDBPanelTabela into
				nm_campo_base_w,
				ds_titulo_w,
				ie_tipo_coluna_w;
			EXIT WHEN NOT FOUND; /* apply on CWDBPanelTabela */
				begin
				insert into	w_colunas_grid_wcpanel(	nr_sequencia,
					dt_atualizacao,
					nm_usuario,
					dt_atualizacao_nrec,
					nm_usuario_nrec,
					cd_funcao,
					nm_coluna,
					ds_titulo_coluna,
					nm_componente,
					cd_codigo,
					nr_seq_objeto,
					nr_seq_visao,
					ie_tipo,
					nm_tabela,
					ie_tipo_coluna
				) values (
					nextval('w_colunas_grid_wcpanel_seq'),
					clock_timestamp(),
					nm_usuario_p,
					clock_timestamp(),
					nm_usuario_p,
					cd_funcao_p,
					nm_campo_base_w,
					ds_titulo_w,
					nm_componente_p,
					null,
					null,
					null,
					ie_tipo_p,
					nm_tabela_p,
					ie_tipo_coluna_w);
				end;
			end loop;
			close CWDBPanelTabela;
			end;
		end if;
		end;
	end if;
	end;
end if;
commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE carregar_colunas_grid_wcpanel ( cd_funcao_p bigint, nm_componente_p text, ie_tipo_p text, nr_seq_objeto_p bigint default null, nm_coluna_p text default null, ds_titulo_coluna_p text default null, nr_seq_visao_p bigint default null, nm_tabela_p text default null, nm_usuario_p text DEFAULT NULL) FROM PUBLIC;
