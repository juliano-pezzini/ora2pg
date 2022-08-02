-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_imp_pacote_federacao_pr ( nr_seq_lote_p INOUT bigint, ds_conteudo_p text, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE


ds_conteudo_w			varchar(4000);
ds_valor_w			varchar(255);
nr_seq_lote_w			pls_imp_lote_pacote.nr_sequencia%type;
dt_inicio_vigencia_w		pls_imp_pacote.dt_inicio_vigencia%type;
dt_inicio_vigencia_aux_w	varchar(20);
cd_tipo_tabela_imp_w		pls_imp_pacote.cd_tipo_tabela_imp%type;
cd_pacote_w			pls_imp_pacote.cd_pacote%type;
cd_tipo_tabela_comp_w		pls_imp_pacote.cd_tipo_tabela_comp%type;
qt_composicao_w			pls_imp_pacote.qt_composicao%type;
vl_unit_composicao_w		pls_imp_pacote.vl_unit_composicao%type;
vl_tot_composicao_w		pls_imp_pacote.vl_tot_composicao%type;
cd_composicao_w			pls_imp_pacote.cd_composicao%type;
qt_registros_w			integer;


BEGIN

if (coalesce(nr_seq_lote_p::text, '') = '') then

	select	nextval('pls_imp_lote_pacote_seq')
	into STRICT	nr_seq_lote_w
	;

	insert into pls_imp_lote_pacote(	nr_sequencia,dt_atualizacao,nm_usuario,dt_atualizacao_nrec,nm_usuario_nrec)
	values (	nr_seq_lote_w,clock_timestamp(),nm_usuario_p,clock_timestamp(),nm_usuario_p);

	nr_seq_lote_p	:= nr_seq_lote_w;

end if;

ds_conteudo_w	:= ds_conteudo_p;

if (upper(ds_conteudo_w) like '%INICIO%') then
	goto final;
end if;

qt_registros_w	:= 0;

while(ds_conteudo_w IS NOT NULL AND ds_conteudo_w::text <> '') loop
	if (position(';' in ds_conteudo_w) = 0) then
		ds_valor_w	:= ds_conteudo_w;
		ds_conteudo_w	:= null;
	else
		ds_valor_w	:= substr(ds_conteudo_w,1,position(';' in ds_conteudo_w) - 1);
		ds_conteudo_w	:= substr(ds_conteudo_w,position(';' in ds_conteudo_w) + 1,length(ds_conteudo_w));
	end if;

	qt_registros_w	:= qt_registros_w + 1;

	/*Inicio de vigência */

	if (qt_registros_w = 1) then
		dt_inicio_vigencia_aux_w	:= ds_valor_w;
		dt_inicio_vigencia_w		:= to_date(dt_inicio_vigencia_aux_w,'dd/mm/yyyy');
	/*Tipo de tabela de serviço */

	elsif (qt_registros_w = 2) then
		cd_tipo_tabela_imp_w		:= ds_valor_w;
	/*Código do pacote */

	elsif (qt_registros_w = 3) then
		cd_pacote_w			:= ds_valor_w;
	/*Tipo tabela comp*/

	elsif (qt_registros_w = 4) then
		cd_tipo_tabela_comp_w		:= ds_valor_w;
	/*Composição */

	elsif (qt_registros_w = 5) then
		cd_composicao_w			:= ds_valor_w;
	/*Quantidade*/

	elsif (qt_registros_w = 6) then
		qt_composicao_w			:= somente_numero_virg_char(ds_valor_w);
	/*Valor unitário*/

	elsif (qt_registros_w = 7) then
		vl_unit_composicao_w		:= somente_numero_virg_char(replace(ds_valor_w,'.',''));
	/*Valor total*/

	elsif (qt_registros_w = 8) then
		vl_tot_composicao_w		:= somente_numero_virg_char(replace(ds_valor_w,'.',''));
	end if;

end loop;

insert into pls_imp_pacote(	nr_sequencia,dt_atualizacao,nm_usuario,dt_atualizacao_nrec,nm_usuario_nrec,
		nr_seq_lote_pct,dt_inicio_vigencia,cd_tipo_tabela_imp,cd_pacote,cd_tipo_tabela_comp,
		cd_composicao,qt_composicao,vl_unit_composicao,vl_tot_composicao)
values (	nextval('pls_imp_pacote_seq'),clock_timestamp(),nm_usuario_p,clock_timestamp(),nm_usuario_p,
		nr_seq_lote_p,dt_inicio_vigencia_w,cd_tipo_tabela_imp_w,cd_pacote_w,cd_tipo_tabela_comp_w,
		cd_composicao_w,qt_composicao_w,vl_unit_composicao_w,vl_tot_composicao_w);

commit;

<<final>>
qt_registros_w	:= 0;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_imp_pacote_federacao_pr ( nr_seq_lote_p INOUT bigint, ds_conteudo_p text, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;

