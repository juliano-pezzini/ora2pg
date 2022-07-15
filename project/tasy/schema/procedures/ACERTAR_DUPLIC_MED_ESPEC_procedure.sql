-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE acertar_duplic_med_espec (cd_pessoa_origem_p text, cd_pessoa_destino_p text) AS $body$
DECLARE


cd_especialidade_w	integer;
qt_destino_w		bigint;
ie_param_45	varchar(1) := 'N';


BEGIN

insert into medico_especialidade(
					cd_pessoa_fisica,
					cd_especialidade,
					dt_atualizacao,
					nm_usuario,
					nr_seq_prioridade,
					nr_seq_cbo_saude,
					nr_rqe
					)
SELECT					cd_pessoa_destino_p,
					a.cd_especialidade,
					a.dt_atualizacao,
					a.nm_usuario,
					a.nr_seq_prioridade,
					a.nr_seq_cbo_saude,
					nr_rqe
from					medico_especialidade a
where					a.cd_pessoa_fisica = cd_pessoa_origem_p
and					not exists (	SELECT	1
							from	medico_especialidade x
							where	x.cd_pessoa_fisica	= cd_pessoa_destino_p
							and	x.cd_especialidade	= a.cd_especialidade);


CALL acertar_duplic_med_plantao(cd_pessoa_origem_p,cd_pessoa_destino_p);

ie_param_45 := obter_param_usuario(4, 45, Obter_perfil_Ativo, wheb_usuario_pck.get_nm_usuario, wheb_usuario_pck.get_cd_estabelecimento, ie_param_45);

if (ie_param_45 = 'N')then
  delete
  from	medico_especialidade
  where	cd_pessoa_fisica = cd_pessoa_origem_p;
else
  CALL acertar_duplic_med_tiss_cbo(cd_pessoa_origem_p, cd_pessoa_destino_p);
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE acertar_duplic_med_espec (cd_pessoa_origem_p text, cd_pessoa_destino_p text) FROM PUBLIC;

