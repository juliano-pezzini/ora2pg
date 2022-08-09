-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE consistir_pedido_kit ( cd_kit_material_p bigint, nm_usuario_p text, nr_seq_agenda_p bigint, ds_erro_p INOUT text) AS $body$
DECLARE

					  
ds_mensagem_w			varchar(255) := null;	
--ds_mensagem_ww			varchar2(255) := null;	 
ie_cons_se_possui_lanc_w	varchar(1);
nr_seq_agenda_w			bigint;
ie_inativo_w			varchar(1);
ie_filtrar_Kit_mat_estab_w	varchar(1);
cd_estabelecimento_w	estabelecimento.cd_estabelecimento%type;
cd_estab_exclusivo_w	kit_material.cd_estab_exclusivo%type;

 
c01 CURSOR FOR 
	SELECT	wheb_mensagem_pck.get_texto(278539) -- O kit já possui lançamento neste agendamento! Parâmetro[744]. 
	from	agenda_pac_pedido b, 
		agenda_pac_pedido_kit c, 
		kit_material d 
	where	b.nr_sequencia	    = c.nr_seq_pedido 
	and	c.cd_kit_material   = d.cd_kit_material 
	and	coalesce(d.ie_situacao,'A') = 'A' 
	and	d.cd_kit_material   = cd_kit_material_p 			 		 
	and 	b.nr_seq_agenda	    = nr_seq_agenda_p;
	

BEGIN 
 
ds_erro_p := null;
ie_filtrar_Kit_mat_estab_w := obter_param_usuario(871, 827, wheb_usuario_pck.get_cd_perfil, nm_usuario_p, wheb_usuario_pck.get_cd_estabelecimento, ie_filtrar_Kit_mat_estab_w);
 
select	max(CASE WHEN count(1)=0 THEN  'N'  ELSE 'S' END ) 
into STRICT	ie_inativo_w 
from	kit_material d 
where	coalesce(d.ie_situacao,'A') = 'I' 
and		d.cd_kit_material   = cd_kit_material_p 
group by cd_kit_material;
 
if (coalesce(ie_inativo_w,'N') = 'S') then 
	ds_erro_p := wheb_mensagem_pck.get_texto(823197);
end if;
 
if (coalesce(cd_kit_material_p,0) > 0) and (coalesce(ie_inativo_w,'N') = 'N') then 
	ie_cons_se_possui_lanc_w := obter_param_usuario(871, 744, wheb_usuario_pck.get_cd_perfil, nm_usuario_p, wheb_usuario_pck.get_cd_estabelecimento, ie_cons_se_possui_lanc_w);
	if (ie_cons_se_possui_lanc_w = 'S') then 
		open C01;
		loop 
		fetch C01 into	 
			ds_mensagem_w;
		EXIT WHEN NOT FOUND; /* apply on C01 */
			begin 
			ds_erro_p := wheb_mensagem_pck.get_texto(278539); -- O kit já possui lançamento neste agendamento! Parâmetro[744]. 
			end;
		end loop;
		close C01;
	end if;	
	 
	/*if (ds_mensagem_ww is not null) then 
		Wheb_mensagem_pck.exibir_mensagem_abort(226610,'DS_MENSAGEM='||ds_mensagem_ww); 
	end if;*/
 
	 
end if;
 
if (coalesce(ie_filtrar_Kit_mat_estab_w,'N') = 'S') then 
	select	coalesce(max(cd_estabelecimento),0) cd_estabelecimento 
	into STRICT	cd_estabelecimento_w 
	from 	agenda 
	where 	cd_agenda = obter_codigo_agenda_pac(nr_seq_agenda_p);
	 
	select	coalesce(max(cd_estab_exclusivo),0) cd_estab_exclusivo 
	into STRICT	cd_estab_exclusivo_w 
	from	kit_material 
	where	cd_kit_material = cd_kit_material_p;
	 
	if (coalesce(cd_estabelecimento_w,0) <> coalesce(cd_estab_exclusivo_w,0) and coalesce(cd_estabelecimento_w,0) > 0 and coalesce(cd_estab_exclusivo_w,0) > 0 ) then 
		ds_erro_p := wheb_mensagem_pck.get_texto(844050); /*Não é possível utilizar o kit material no estabelecimento da agenda selecionada.*/
	end if;
end if;
	 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE consistir_pedido_kit ( cd_kit_material_p bigint, nm_usuario_p text, nr_seq_agenda_p bigint, ds_erro_p INOUT text) FROM PUBLIC;
