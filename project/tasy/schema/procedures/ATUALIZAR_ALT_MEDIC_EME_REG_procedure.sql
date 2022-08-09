-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizar_alt_medic_eme_reg ( nr_sequencia_p bigint, nm_usuario_p text) AS $body$
DECLARE


nm_usuario_alt_w	varchar(15);
ds_erro_w		varchar(1000);

BEGIN
if (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '') and (nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '') then
	begin
	select 	coalesce(nm_usuario_alt,'')
	into STRICT	nm_usuario_alt_w
	from	eme_regulacao
	where	nr_sequencia = nr_sequencia_p;

	if (nm_usuario_alt_w <> '') then
		begin
		ds_erro_w := obter_texto_dic_objeto(75511, wheb_usuario_pck.get_nr_seq_idioma, 'NM_USUARIO_ALT='|| nm_usuario_alt_w);
		CALL WHEB_MENSAGEM_PCK.Exibir_Mensagem_Abort(278178,'DS_ERRO='||ds_erro_w);
		end;
	else
		begin
		update	eme_regulacao
		set	nm_usuario_alt	= nm_usuario_p
		where	nr_sequencia	= nr_sequencia_p;
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
-- REVOKE ALL ON PROCEDURE atualizar_alt_medic_eme_reg ( nr_sequencia_p bigint, nm_usuario_p text) FROM PUBLIC;
