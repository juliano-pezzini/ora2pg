-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_dados_loco_regional ( cd_pessoa_fisica_p text, ie_tipo_p bigint) RETURNS varchar AS $body$
DECLARE


/*	IE_TIPO_P
	1 - Abreviatua do TNM
	2 - Cid mofologico
	3 - Cid topografico
	4 - Carboplatina
	5 - Descricao do CID10
*/
cd_tumor_primario_w		can_loco_regional.cd_tumor_primario%type;
cd_linfonodo_regional_w		can_loco_regional.cd_linfonodo_regional%type;
cd_metastase_distancia_w	can_loco_regional.cd_metastase_distancia%type;
cd_morfologia_w			varchar(10);
cd_topografia_W			varchar(10);
ds_retorno_w			varchar(255);
qt_mg_carboplatina_w		double precision;
qt_mg_carboplatina_ww		double precision;
cd_doenca_cid_w			varchar(10);


BEGIN

  begin
  select	qt_mg_carboplatina
  into STRICT	qt_mg_carboplatina_ww
  from	paciente_setor
  where	cd_pessoa_fisica	= cd_pessoa_fisica_p
  and	nr_seq_paciente		= (	SELECT	max(a.nr_seq_paciente)
            from	paciente_setor a
            where	cd_pessoa_fisica	= cd_pessoa_fisica_p);
  exception
  when others then
    qt_mg_carboplatina_ww	:= null;
  end;

  
  begin
    select	replace(cd_tumor_primario,'T',null),
      replace(cd_linfonodo_regional,'N',null),
      replace(cd_metastase_distancia,'M',null),
      cd_morfologia,
      cd_topografia,
      coalesce(qt_mg_carboplatina_ww, qt_mg_carboplatina),
      cd_doenca_cid
    into STRICT	cd_tumor_primario_w,
      cd_linfonodo_regional_w,
      cd_metastase_distancia_w,
    cd_morfologia_w,
      cd_topografia_W,
      qt_mg_carboplatina_w,
      cd_doenca_cid_w	
    from	can_loco_regional
    where	nr_sequencia	=	(SELECT	max(c.nr_sequencia)
            from	can_loco_regional c
            where	c.cd_pessoa_fisica = cd_pessoa_fisica_p
          	and c.ie_situacao = 'A');
    exception
      when others then
        cd_tumor_primario_w		:= null;
        cd_linfonodo_regional_w		:= null;
        cd_metastase_distancia_w	:= null;
        cd_morfologia_w			:= null;
        cd_topografia_W			:= null;
        qt_mg_carboplatina_w		:= 0;
  end;

  if (ie_tipo_p	= 1) then
    ds_retorno_w	:= cd_tumor_primario_w || cd_linfonodo_regional_w || cd_metastase_distancia_w;
  elsif (ie_tipo_p	= 2) then
    ds_retorno_w	:= cd_morfologia_w;
  elsif (ie_tipo_p	= 3) then
    ds_retorno_w	:= cd_topografia_W;
  elsif (ie_tipo_p	= 4) then
    ds_retorno_w	:= qt_mg_carboplatina_w;
  elsif (ie_tipo_p	= 5) then
    ds_retorno_w	:= substr(cd_doenca_cid_w || ' - '|| obter_desc_cid(cd_doenca_cid_w),1,255);
  end if;

  return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_dados_loco_regional ( cd_pessoa_fisica_p text, ie_tipo_p bigint) FROM PUBLIC;

