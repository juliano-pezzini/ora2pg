-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE cancelar_biometria_pf ( nr_seq_biometria_p bigint, nr_seq_motivo_p bigint, ds_observacao_p text, nm_usuario_p text, cd_estabelecimento_p bigint) AS $body$
DECLARE


cd_pessoa_fisica_w			varchar(15);
ds_biometria_w				varchar(4000);
ie_dedo_w				bigint;


BEGIN

select	cd_pessoa_fisica,
	ds_biometria,
	ie_dedo
into STRICT	cd_pessoa_fisica_w,
	ds_biometria_w,
	ie_dedo_w
from	pessoa_fisica_biometria
where	nr_sequencia	= nr_seq_biometria_p;

insert into pessoa_fisica_biomet_log(	nr_sequencia, cd_pessoa_fisica, cd_estabelecimento, dt_atualizacao, nm_usuario,
					dt_atualizacao_nrec, nm_usuario_nrec, ds_biometria, ie_dedo, nm_usuario_exclusao,
					ds_observacao, dt_cancelamento, nr_seq_motivo_cancelamento)
				values (	nextval('pessoa_fisica_biomet_log_seq'), cd_pessoa_fisica_w, cd_estabelecimento_p, clock_timestamp(), nm_usuario_p,
					clock_timestamp(), nm_usuario_p, ds_biometria_w, ie_dedo_w, nm_usuario_p,
					ds_observacao_p, clock_timestamp(), nr_seq_motivo_p);

delete from	pessoa_fisica_biometria
where	nr_sequencia	= nr_seq_biometria_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE cancelar_biometria_pf ( nr_seq_biometria_p bigint, nr_seq_motivo_p bigint, ds_observacao_p text, nm_usuario_p text, cd_estabelecimento_p bigint) FROM PUBLIC;
