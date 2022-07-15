-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_evento_lib_escala_must ( nm_usuario_p text, nr_atendimento_p bigint) AS $body$
DECLARE



nr_seq_evento_w		bigint;
cd_estabelecimento_w	smallint;
cd_pessoa_fisica_w	varchar(10);
qt_idade_w		bigint;
qt_pontos_w		bigint;

C01 CURSOR FOR
	SELECT	nr_seq_evento
	from	regra_envio_sms
	where	((cd_estabelecimento_w = 0) or (cd_estabelecimento	= cd_estabelecimento_w))
	and	ie_evento_disp		= 'LMUS'
	and	qt_idade_w between coalesce(qt_idade_min,0)	and coalesce(qt_idade_max,9999)
	and	coalesce(ie_situacao,'A') = 'A';


BEGIN
/*
SELECT	MAX(qt_pontuacao)
into 	qt_pontos_w
FROM	escala_must
WHERE	nr_atendimento = nr_atendimento_p
AND	dt_inativacao IS NULL
AND	dt_liberacao IS NOT NULL;

if (qt_pontos_w >= 1) then

	select	max(cd_estabelecimento),
		max(cd_pessoa_fisica)
	into	cd_estabelecimento_w,
		cd_pessoa_fisica_w
	from	atendimento_paciente
	where	nr_atendimento	= nr_atendimento_p;

	qt_idade_w	:= nvl(obter_idade_pf(cd_pessoa_fisica_w,sysdate,'A'),0);

	open C01;
	loop
	fetch C01 into
		nr_seq_evento_w;
	exit when C01%notfound;
		begin
		gerar_evento_paciente_trigger(nr_seq_evento_w,nr_atendimento_p,cd_pessoa_fisica_w,null,nm_usuario_p);
		end;
	end loop;
	close C01;

commit;
end if;

*/
null;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_evento_lib_escala_must ( nm_usuario_p text, nr_atendimento_p bigint) FROM PUBLIC;

