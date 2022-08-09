-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE cirurgia_afterpost ( cd_estabelecimento_p bigint, nr_cirurgia_p bigint, nr_seq_agenda_p bigint, nm_usuario_p text ) AS $body$
DECLARE

 
nr_prescricao_w		bigint;
GerarKit      varchar(1);
ie_tipo_pessoa_w  varchar(1);


BEGIN 
 
GerarKit 	:= obter_valor_param_usuario(281,1227,obter_perfil_ativo,nm_usuario_p,0);
 
if (nr_cirurgia_p IS NOT NULL AND nr_cirurgia_p::text <> '') and (nr_seq_agenda_p IS NOT NULL AND nr_seq_agenda_p::text <> '') then 
	begin 
 
	nr_prescricao_w := gerar_prescr_cirurgia(cd_estabelecimento_p, nr_cirurgia_p, nr_seq_agenda_p, nm_usuario_p, nr_prescricao_w);
 
	if (nr_prescricao_w IS NOT NULL AND nr_prescricao_w::text <> '')	then 
		begin 
 
		update	cirurgia 
		set	nr_prescricao = nr_prescricao_w 
		where	nr_cirurgia = nr_cirurgia_p;
 
		commit;
		end;
	end if;								
	end;
	 
	if (GerarKit = 'S') then	 
		select b.ie_tipo_pessoa 
			into STRICT ie_tipo_pessoa_w 
		from	usuario a, 
			pessoa_fisica b 
		where  a.cd_pessoa_fisica 	= 	b.cd_pessoa_fisica 
		and	a.nm_usuario	=	nm_usuario_p;
 
		CALL Gerar_prescricao_cirurgia(0,0,nr_cirurgia_p,0,ie_tipo_pessoa_w,nm_usuario_p,nr_prescricao_w,0,null,281,Obter_perfil_Ativo,null,null,null,null);
	end if;
 
end if;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE cirurgia_afterpost ( cd_estabelecimento_p bigint, nr_cirurgia_p bigint, nr_seq_agenda_p bigint, nm_usuario_p text ) FROM PUBLIC;
