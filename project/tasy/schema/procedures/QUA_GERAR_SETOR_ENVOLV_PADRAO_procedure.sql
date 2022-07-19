-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE qua_gerar_setor_envolv_padrao ( nr_seq_nao_conform_p bigint, nm_usuario_p text) AS $body$
DECLARE



nr_seq_tipo_w		bigint;
ie_permite_setor_w		varchar(03);
cd_setor_atendimento_w	integer;
nr_seq_grupo_usuario_w	bigint;
cd_estab_w		smallint := wheb_usuario_pck.get_cd_estabelecimento;
nm_usuario_w		varchar(15);


C01 CURSOR FOR
SELECT	cd_setor_atendimento,
	nr_seq_grupo_usuario,
	nm_usuario_lib
from	qua_tipo_nc_setor_padrao
where	nr_seq_tipo = nr_seq_tipo_w
and	coalesce(cd_estabelecimento_lib,cd_estab_w) = cd_estab_w;




BEGIN

select	nr_seq_tipo
into STRICT	nr_seq_tipo_w
from	qua_nao_conformidade
where	nr_sequencia = nr_seq_nao_conform_p;

select	substr(qua_obter_tipo_nao_conform(nr_seq_tipo_w, 'S'),1,3)
into STRICT	ie_permite_setor_w
;



if (ie_permite_setor_w <> 'NI') then
	begin
	open C01;
	loop
	fetch C01 into
		cd_setor_atendimento_w,
		nr_seq_grupo_usuario_w,
		nm_usuario_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin



		insert into qua_nao_conform_setor(
			nr_sequencia,
			nr_seq_nao_conform,
			dt_atualizacao,
			nm_usuario,
			cd_setor_atendimento,
			dt_atualizacao_nrec,
			nm_usuario_nrec,
			nm_usuario_destino,
			nr_seq_grupo_usuario_dest)
		values (	nextval('qua_nao_conform_setor_seq'),
			nr_seq_nao_conform_p,
			clock_timestamp(),
			nm_usuario_p,
			cd_setor_atendimento_w,
			clock_timestamp(),
			nm_usuario_p,
			coalesce(nm_usuario_w,nm_usuario_p),  --null,
			nr_seq_grupo_usuario_w);
		end;
	end loop;
	close C01;
	end;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE qua_gerar_setor_envolv_padrao ( nr_seq_nao_conform_p bigint, nm_usuario_p text) FROM PUBLIC;

