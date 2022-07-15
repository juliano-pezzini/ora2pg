-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE copiar_menu_item ( nr_sequencia_p bigint, nr_seq_wpumc_dest_p bigint, nm_usuario_p text) AS $body$
DECLARE


qt_existe_w				smallint;
nr_seq_item_w			dic_objeto.nr_sequencia%type;


BEGIN

select	count(*)
into STRICT	qt_existe_w
from	dic_objeto
where	nr_sequencia = nr_seq_wpumc_dest_p
and	ie_tipo_objeto = 'M';

if (qt_existe_w > 0) then
	begin

	select	nextval('dic_objeto_seq')
	into STRICT	nr_seq_item_w
	;

	insert into dic_objeto(
		nr_sequencia,
		dt_atualizacao,
		nm_usuario,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		ie_tipo_objeto,
		nm_objeto,
		ds_texto,
		nr_seq_obj_sup,
		ds_informacao,
		cd_funcao,
		ie_atalho,
		ie_ctrl,
		ie_shift,
		ie_alt,
		ie_objeto_nulo,
		ie_tipo_obj_menu,
		ie_configuravel,
		nm_objeto_orig,
		cd_exp_texto,
		cd_exp_informacao,
		nr_seq_apres)
	SELECT nr_seq_item_w,
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p,
		ie_tipo_objeto,
		nm_objeto,
		ds_texto,
		nr_seq_wpumc_dest_p,
		ds_informacao,
		cd_funcao,
		ie_atalho,
		ie_ctrl,
		ie_shift,
		ie_alt,
		ie_objeto_nulo,
		ie_tipo_obj_menu,
		ie_configuravel,
		nm_objeto_orig,
		cd_exp_texto,
		cd_exp_informacao,
		nr_seq_apres
	from	dic_objeto
	where	nr_sequencia = nr_sequencia_p;

	commit;

	end;
end if;

end	;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE copiar_menu_item ( nr_sequencia_p bigint, nr_seq_wpumc_dest_p bigint, nm_usuario_p text) FROM PUBLIC;

