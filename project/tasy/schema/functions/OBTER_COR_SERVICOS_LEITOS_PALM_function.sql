-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_cor_servicos_leitos_palm (nr_sequencia_p text, cd_perfil_p bigint, cd_estabelecimento_p bigint) RETURNS varchar AS $body$
DECLARE


ds_cor_fundo_w		varchar(50);
ds_cor_fonte_w		varchar(50);
ds_cor_selecao_w	varchar(50);
dt_prevista_w		timestamp;
dt_inicio_w		timestamp;
ie_prioridade_w		varchar(1);
ie_status_serv_w	varchar(5);


BEGIN

select	dt_prevista,
	dt_inicio,
	ie_prioridade,
	ie_status_serv
into STRICT
	dt_prevista_w,
	dt_inicio_w,
	ie_prioridade_w,
	ie_status_serv_w
from 	sl_unid_atend
where 	nr_sequencia	= nr_sequencia_p;



if ( ie_status_serv_w = 'P') then
	SELECT * FROM tasy_obter_cor(575, cd_perfil_p, cd_estabelecimento_p, ds_cor_fundo_w, ds_cor_fonte_w, ds_cor_selecao_w) INTO STRICT ds_cor_fundo_w, ds_cor_fonte_w, ds_cor_selecao_w;
elsif ( ie_status_serv_w = 'IP') then
	SELECT * FROM tasy_obter_cor(1144, cd_perfil_p, cd_estabelecimento_p, ds_cor_fundo_w, ds_cor_fonte_w, ds_cor_selecao_w) INTO STRICT ds_cor_fundo_w, ds_cor_fonte_w, ds_cor_selecao_w;
elsif (( ie_status_serv_w = 'EE') or (ie_status_serv_w = 'FP')) then
	SELECT * FROM tasy_obter_cor(576, cd_perfil_p, cd_estabelecimento_p, ds_cor_fundo_w, ds_cor_fonte_w, ds_cor_selecao_w) INTO STRICT ds_cor_fundo_w, ds_cor_fonte_w, ds_cor_selecao_w;
elsif ( ie_status_serv_w = 'E') then
	SELECT * FROM tasy_obter_cor(577, cd_perfil_p, cd_estabelecimento_p, ds_cor_fundo_w, ds_cor_fonte_w, ds_cor_selecao_w) INTO STRICT ds_cor_fundo_w, ds_cor_fonte_w, ds_cor_selecao_w;
elsif ( ie_status_serv_w = 'A') then
	SELECT * FROM tasy_obter_cor(1207, cd_perfil_p, cd_estabelecimento_p, ds_cor_fundo_w, ds_cor_fonte_w, ds_cor_selecao_w) INTO STRICT ds_cor_fundo_w, ds_cor_fonte_w, ds_cor_selecao_w;
elsif ( ie_status_serv_w = 'C') then
	SELECT * FROM tasy_obter_cor(578, cd_perfil_p, cd_estabelecimento_p, ds_cor_fundo_w, ds_cor_fonte_w, ds_cor_selecao_w) INTO STRICT ds_cor_fundo_w, ds_cor_fonte_w, ds_cor_selecao_w;
end if;

if ( ie_status_serv_w = 'IT') then
	SELECT * FROM tasy_obter_cor(1335, cd_perfil_p, cd_estabelecimento_p, ds_cor_fundo_w, ds_cor_fonte_w, ds_cor_selecao_w) INTO STRICT ds_cor_fundo_w, ds_cor_fonte_w, ds_cor_selecao_w;
end if;

if (( dt_prevista_w < clock_timestamp()) and (coalesce(dt_inicio_w::text, '') = '') and (ie_status_serv_w <> 'C') and (ie_status_serv_w <> 'IT'))then
	SELECT * FROM tasy_obter_cor(580, cd_perfil_p, cd_estabelecimento_p, ds_cor_fundo_w, ds_cor_fonte_w, ds_cor_selecao_w) INTO STRICT ds_cor_fundo_w, ds_cor_fonte_w, ds_cor_selecao_w;
end if;


ds_cor_fundo_w	:=	converte_Cor_Delphi_RGB(ds_cor_fundo_w);




return	ds_cor_fundo_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_cor_servicos_leitos_palm (nr_sequencia_p text, cd_perfil_p bigint, cd_estabelecimento_p bigint) FROM PUBLIC;
