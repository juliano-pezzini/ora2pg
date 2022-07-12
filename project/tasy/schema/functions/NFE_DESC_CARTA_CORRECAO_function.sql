-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION nfe_desc_carta_correcao ( nr_seq_nota_p text) RETURNS varchar AS $body$
DECLARE



ds_descricao_w		varchar(1000);
ds_tipo_correcao_w	varchar(80);
ie_tipo_correcao_w		integer;
vl_anterior_w		varchar(255);
vl_atual_w		varchar(255);
ds_material_w		material.ds_material%type;
ds_tributo_w		tributo.ds_tributo%type;


c01 CURSOR FOR
	SELECT	f.ie_tipo_correcao,
		f.vl_anterior,
		CASE WHEN ie_tipo_correcao=1 THEN  substr(obter_dados_pf_pj(null,f.cd_cgc_emitente, 'N'),1,255) WHEN ie_tipo_correcao=3 THEN  substr(obter_sus_municipio(cd_municipio_ibge), 1, 255) WHEN ie_tipo_correcao=4 THEN  f.sg_estado WHEN ie_tipo_correcao=5 THEN  f.cd_cgc_emitente WHEN ie_tipo_correcao=12 THEN  substr(fis_obter_unidade_medida(cd_unidade_medida), 1, 255) WHEN ie_tipo_correcao=17 THEN  substr(obter_dados_ncm(cd_ncm, 'C'), 1, 255) WHEN ie_tipo_correcao=44 THEN  substr(fis_obter_tipo_frete(f.ie_tipo_frete), 1, 255) WHEN ie_tipo_correcao=45 THEN  f.ie_tributacao_cst   ELSE f.vl_atual END ,
		substr(obter_valor_dominio(5442,f.ie_tipo_correcao),1,255),
		CASE WHEN coalesce(f.cd_material::text, '') = '' THEN Obter_Desc_Procedimento(f.cd_procedimento,f.ie_origem_proced)  ELSE obter_desc_material(f.cd_material) END ,
		obter_desc_tributo(f.cd_tributo)
	from	nota_fiscal n,
		fis_carta_correcao f
	where	n.nr_sequencia = f.nr_seq_nota_fiscal
	and	n.nr_sequencia = nr_seq_nota_p
	and	(nm_usuario_liberacao IS NOT NULL AND nm_usuario_liberacao::text <> '')
	order by f.ie_tipo_correcao desc;


BEGIN

CALL philips_param_pck.set_nr_seq_idioma(1);

ds_descricao_w := WHEB_MENSAGEM_PCK.get_texto(312093); --Correcao dos seguintes valores:
open c01;
loop
fetch c01 into
	ie_tipo_correcao_w,
	vl_anterior_w,
	vl_atual_w,
	ds_tipo_correcao_w,
	ds_material_w,
	ds_tributo_w;
EXIT WHEN NOT FOUND; /* apply on c01 */

	if (ie_tipo_correcao_w = 45) then
	   begin
		ds_descricao_w := substr(ds_descricao_w || ds_tipo_correcao_w || WHEB_MENSAGEM_PCK.get_texto(312094,'DS_MATERIAL_W=' || ds_material_w || ';DS_TRIBUTO_W=' || ds_tributo_w || ';VL_ANTERIOR_W=' || vl_anterior_w) || vl_atual_w || ' . ', 0, 999);	 --' do item ' ||  ds_material_w || ' tributo de ' || ds_tributo_w || ' com o valor anterior ' || vl_anterior_w || ', será substituido por
	   end;
	elsif (ie_tipo_correcao_w = 47) then
	   begin
		ds_descricao_w := substr(ds_descricao_w || ds_tipo_correcao_w || ' ' || ds_material_w || WHEB_MENSAGEM_PCK.get_texto(312095, 'VL_ANTERIOR_W=' || vl_anterior_w) || vl_atual_w || ' . ', 0, 999); -- ds_material_w 'com o valor anterior ' || vl_anterior_w || ', será substituido por '
	   end;
	elsif (ie_tipo_correcao_w = 39) then
           begin
               ds_descricao_w := substr(ds_descricao_w || ds_tipo_correcao_w || WHEB_MENSAGEM_PCK.get_texto(988754,'DS_MATERIAL_W=' || ds_material_w || ';VL_ANTERIOR_W=' || vl_anterior_w) || vl_atual_w || ' . ', 0, 999);	 --' do item ' ||  ds_material_w ||  ' com o valor anterior ' || vl_anterior_w || ', será substituido por
           end;
	else
	   begin
		ds_descricao_w := substr(ds_descricao_w || ds_tipo_correcao_w || WHEB_MENSAGEM_PCK.get_texto(312095, 'VL_ANTERIOR_W=' || vl_anterior_w) || vl_atual_w || ' . ', 0, 999); --' com o valor anterior ' || vl_anterior_w || ', será substituido por '
	   end;
	end if;


end loop;
close c01;

return nfe_elimina_caractere_especial(ds_descricao_w);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION nfe_desc_carta_correcao ( nr_seq_nota_p text) FROM PUBLIC;

