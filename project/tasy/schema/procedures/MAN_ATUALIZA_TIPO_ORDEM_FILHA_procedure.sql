-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE man_atualiza_tipo_ordem_filha (nr_seq_ordem_serv_p bigint, nr_seq_tipo_ordem_p bigint, nm_usuario_p text) AS $body$
DECLARE


qt_os_filhas_w			bigint;


BEGIN


if (obter_se_base_corp = 'S' or obter_se_base_wheb = 'S') then

  select	count(1)
	into STRICT	qt_os_filhas_w
	from	man_ordem_serv_filha
	where	nr_seq_ordem_serv = nr_seq_ordem_serv_p;
	
	if (qt_os_filhas_w > 0) then
		update	man_ordem_servico
		set		nr_seq_tipo_ordem		=	nr_seq_tipo_ordem_p
		where	nr_seq_ordem_serv_pai	=	nr_seq_ordem_serv_p
		and		nr_seq_tipo_ordem		<>	nr_seq_tipo_ordem_p;
	end if;
	
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE man_atualiza_tipo_ordem_filha (nr_seq_ordem_serv_p bigint, nr_seq_tipo_ordem_p bigint, nm_usuario_p text) FROM PUBLIC;

