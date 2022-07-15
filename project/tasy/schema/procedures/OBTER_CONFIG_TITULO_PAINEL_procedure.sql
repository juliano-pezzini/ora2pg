-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE obter_config_titulo_painel ( cd_estab_atual_p bigint, nm_usuario_p text, cd_lista_estab_p text, ds_titulo_p INOUT text, cd_estab_retorno_p INOUT bigint, qt_tamanho_fonte_p INOUT bigint, ds_cor_fonte_p INOUT text, ds_cor_fundo_p INOUT text, ie_regra_p INOUT text, qt_horas_p INOUT bigint, qt_seq_alteracao_estab_p INOUT bigint, qt_tamanho_painel_p INOUT bigint) AS $body$
DECLARE



nr_seq_prioridade_atual_w	bigint;
cd_estabelecimento_w		smallint;
cd_lista_estab_w		varchar(255);
ds_cor_fonte_w			varchar(15);
ds_cor_fundo_w			varchar(15);
ds_titulo_w			varchar(255);
ie_regra_w			varchar(15);
nr_seq_prioridade_w		bigint;
qt_horas_w			bigint;
qt_tamanho_fonte_w		bigint;
nr_sequencia_ww			bigint;
nr_sequencia_w			bigint;
qt_seq_alteracao_estab_w	bigint;
qt_tamanho_painel_w		bigint;

C01 CURSOR FOR
	SELECT	nr_seq_prioridade,
		nr_sequencia
	from	regra_painel_cirurgico
	where   coalesce(ie_situacao,'A') = 'A'
	and	obter_se_contido_char(cd_estabelecimento,cd_lista_estab_w) = 'S'
	order by nr_seq_prioridade;


BEGIN
cd_lista_estab_w := substr(cd_lista_estab_p,1,255);
if (coalesce(cd_lista_estab_w::text, '') = '') then
	cd_lista_estab_w := wheb_usuario_pck.get_cd_estabelecimento;
end if;

nr_sequencia_ww := 0;

select  coalesce(max(nr_seq_prioridade),-1)
into STRICT    nr_seq_prioridade_atual_w
from	regra_painel_cirurgico
where   cd_estabelecimento = cd_estab_atual_p
and	obter_se_contido_char(cd_estabelecimento,cd_lista_estab_w) = 'S'
and	coalesce(ie_situacao,'A') = 'A';


open C01;
loop
fetch C01 into
	nr_seq_prioridade_w,
	nr_sequencia_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	if (nr_sequencia_ww = 0) and (nr_seq_prioridade_atual_w > -1) and (nr_seq_prioridade_w > nr_seq_prioridade_atual_w) then
		nr_sequencia_ww := nr_sequencia_w;
	end if;
	end;
end loop;
close C01;

if (nr_sequencia_ww > 0) then
	select	max(cd_estabelecimento),
		max(ds_cor_fonte),
		max(ds_cor_fundo),
		max(ds_titulo),
		max(ie_regra),
		max(nr_seq_prioridade),
		max(qt_horas),
		max(qt_tamanho_fonte),
		max(qt_seq_alteracao_estab),
		MAX(qt_tamanho_painel)
	into STRICT	cd_estabelecimento_w,
		ds_cor_fonte_w,
		ds_cor_fundo_w,
		ds_titulo_w,
		ie_regra_w,
		nr_seq_prioridade_w,
		qt_horas_w,
		qt_tamanho_fonte_w,
		qt_seq_alteracao_estab_w,
		qt_tamanho_painel_w
	from   	regra_painel_cirurgico
	where  	nr_sequencia = nr_sequencia_ww;
else
	select	max(cd_estabelecimento),
		max(ds_cor_fonte),
		max(ds_cor_fundo),
		max(ds_titulo),
		max(ie_regra),
		max(nr_seq_prioridade),
		max(qt_horas),
		max(qt_tamanho_fonte),
		max(qt_seq_alteracao_estab),
		MAX(qt_tamanho_painel)
	into STRICT	cd_estabelecimento_w,
		ds_cor_fonte_w,
		ds_cor_fundo_w,
		ds_titulo_w,
		ie_regra_w,
		nr_seq_prioridade_w,
		qt_horas_w,
		qt_tamanho_fonte_w,
		qt_seq_alteracao_estab_w,
		qt_tamanho_painel_w
	from   	regra_painel_cirurgico
	where  	coalesce(ie_situacao,'A') = 'A'
	and	obter_se_contido_char(cd_estabelecimento,cd_lista_estab_w) = 'S'
	and	nr_seq_prioridade = (	SELECT 	min(nr_seq_prioridade)
					from 	regra_painel_cirurgico
					where 	coalesce(ie_situacao,'A') = 'A'
					and	obter_se_contido_char(cd_estabelecimento,cd_lista_estab_w) = 'S');
end if;

ds_titulo_p		:= ds_titulo_w;
cd_estab_retorno_p	:= cd_estabelecimento_w;
qt_tamanho_fonte_p	:= qt_tamanho_fonte_w;
ds_cor_fonte_p		:= ds_cor_fonte_w;
ds_cor_fundo_p		:= ds_cor_fundo_w;
ie_regra_p		:= ie_regra_w;
qt_horas_p		:= qt_horas_w;
QT_TAMANHO_PAINEL_P	:= QT_TAMANHO_PAINEL_W;
qt_seq_alteracao_estab_p := qt_seq_alteracao_estab_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE obter_config_titulo_painel ( cd_estab_atual_p bigint, nm_usuario_p text, cd_lista_estab_p text, ds_titulo_p INOUT text, cd_estab_retorno_p INOUT bigint, qt_tamanho_fonte_p INOUT bigint, ds_cor_fonte_p INOUT text, ds_cor_fundo_p INOUT text, ie_regra_p INOUT text, qt_horas_p INOUT bigint, qt_seq_alteracao_estab_p INOUT bigint, qt_tamanho_painel_p INOUT bigint) FROM PUBLIC;

