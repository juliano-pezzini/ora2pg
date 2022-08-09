-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE baca_ajuste_prontuario_pf (nm_usuario_p text) AS $body$
DECLARE



cd_pessoa_fisica_w	pessoa_fisica.cd_pessoa_fisica%type;
nr_prontuario_old_w	pessoa_fisica.nr_prontuario%type;
nr_prontuario_atual_w	pessoa_fisica.nr_prontuario%type;

C01 CURSOR FOR
	SELECT	x.cd_pessoa_fisica,
		x.nr_prontuario nr_prontuario_old,
		a.nr_prontuario nr_prontuario_atual
	from	pessoa_fisica a,
		pessoa_fisica_alteracao x
	where	a.cd_pessoa_fisica = x.cd_pessoa_fisica
	and	x.nr_prontuario <> a.nr_prontuario
	and	x.dt_atualizacao_nrec = (SELECT	min(y.dt_atualizacao_nrec)
					from	pessoa_fisica_alteracao y
					where	y.cd_pessoa_fisica = x.cd_pessoa_fisica
					and	y.nr_prontuario <> a.nr_prontuario
					and	y.dt_atualizacao_nrec between to_date('06/08/2021','dd/mm/yyyy') and to_date('16/08/2021','dd/mm/yyyy')
					and	y.nm_usuario <> 'BACA_PRONT'
					and	(y.nr_prontuario IS NOT NULL AND y.nr_prontuario::text <> ''));


BEGIN


open C01;
loop
fetch C01 into	
	cd_pessoa_fisica_w,
	nr_prontuario_old_w,
	nr_prontuario_atual_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin

	update 	pessoa_fisica
	set	nr_prontuario  = nr_prontuario_old_w,
		nm_usuario = nm_usuario_p,
		dt_atualizacao = clock_timestamp()
	where	cd_pessoa_fisica = cd_pessoa_fisica_w;

	CALL gravar_log_tasy(9054,'Baca_Ajuste_Prontuario_PF, Pessoa fisica: '||cd_pessoa_fisica_w||' - alterado prontuario: '||nr_prontuario_atual_w||' para: '||nr_prontuario_old_w||', que era o numero de prontuario anterior.',nm_usuario_p);

	end;
end loop;
close C01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE baca_ajuste_prontuario_pf (nm_usuario_p text) FROM PUBLIC;
