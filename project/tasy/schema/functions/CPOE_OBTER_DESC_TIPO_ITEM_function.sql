-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION cpoe_obter_desc_tipo_item ( ie_tipo_item_p text) RETURNS varchar AS $body$
DECLARE

				
ds_tipo_item_w		varchar(240);
				

BEGIN
if (ie_tipo_item_p IS NOT NULL AND ie_tipo_item_p::text <> '') then

	if (ie_tipo_item_p = 'M') then
		ds_tipo_item_w	:= Wheb_mensagem_pck.get_texto(308901); --'Medicamento';
	elsif (ie_tipo_item_p = 'MAT') then
		ds_tipo_item_w	:= Wheb_mensagem_pck.get_texto(308902); --'Material';
	elsif (ie_tipo_item_p = 'SOL') then
		ds_tipo_item_w	:= Wheb_mensagem_pck.get_texto(308904); --'Solucao';
	elsif (ie_tipo_item_p = 'P') then
		ds_tipo_item_w	:= Wheb_mensagem_pck.get_texto(308905); --'Procedimento';
	elsif (ie_tipo_item_p = 'D') then
		ds_tipo_item_w	:= Wheb_mensagem_pck.get_texto(308906); --'Dieta';
	elsif (ie_tipo_item_p = 'SNE') then
		ds_tipo_item_w	:= Wheb_mensagem_pck.get_texto(294752); --'SNE';
	elsif (ie_tipo_item_p = 'S') then
		ds_tipo_item_w	:= Wheb_mensagem_pck.get_texto(308914); --'Suplemento oral';
	elsif (ie_tipo_item_p = 'DI') then
		ds_tipo_item_w	:= Wheb_mensagem_pck.get_texto(309168); --'dialise';
	elsif (ie_tipo_item_p = 'LD') then
		ds_tipo_item_w	:= Wheb_mensagem_pck.get_texto(309821); --'Leites e derivados';
	elsif (ie_tipo_item_p = 'R') then
		ds_tipo_item_w	:= Wheb_mensagem_pck.get_texto(296989); --'Recomendacao';
	elsif (ie_tipo_item_p = 'O') then
		ds_tipo_item_w	:= Wheb_mensagem_pck.get_texto(296653); --'Gasoterapia';
	elsif (ie_tipo_item_p = 'AP') then
		ds_tipo_item_w	:= Wheb_mensagem_pck.get_texto(728072); --'Anatomia Patologia';			
	elsif (ie_tipo_item_p = 'NPTA') then
		ds_tipo_item_w	:= Wheb_mensagem_pck.get_texto(305646); --'NPT Adulta';
	elsif (ie_tipo_item_p = 'NPTI') then
		ds_tipo_item_w	:= Wheb_mensagem_pck.get_texto(988514); --'NPT Pediatrica';		
	elsif (ie_tipo_item_p in ('H','HM')) then
		ds_tipo_item_w	:= Wheb_mensagem_pck.get_texto(333812); --'Hemoterapia';		
	elsif (ie_tipo_item_p = 'J') then
		ds_tipo_item_w	:= Wheb_mensagem_pck.get_texto(309541); --'Jejum';
	elsif (ie_tipo_item_p = 'NANNPT') then
		ds_tipo_item_w	:= Wheb_mensagem_pck.get_texto(1128271); --'NPT Adulta/enteral'
	end if;	
	
end if;

return ds_tipo_item_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION cpoe_obter_desc_tipo_item ( ie_tipo_item_p text) FROM PUBLIC;

