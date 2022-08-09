-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE consistir_prescr_dialise ( nr_prescricao_p bigint, nr_seq_dialise_p bigint, cd_estabelecimento_p bigint, cd_perfil_p bigint, nm_usuario_p text, ds_erro_p INOUT text) AS $body$
DECLARE



ie_erro_liberar_prescr_w	varchar(1);
ie_erro_w					integer;
nr_seq_erro_w				bigint;
qt_erro_nao_lib_w			bigint;
qt_erro_lib_w				bigint;
cd_convenio_w				integer;
nr_sequencia_w				bigint;


c00 REFCURSOR;


BEGIN

if (coalesce(nr_prescricao_p,0) > 0) then

	if (coalesce(nr_seq_dialise_p,0) > 0) then
		delete
		from	prescr_medica_erro
		where	nr_seq_dialise 	= nr_seq_dialise_p
		and		nr_prescricao		= nr_prescricao_p;

		open c00 for
		SELECT	nr_sequencia
		from    hd_prescricao
		where   nr_sequencia 	=  nr_seq_dialise_p
		and		nr_prescricao	=  nr_prescricao_p;
	else
		delete
		from	prescr_medica_erro
		where	(nr_seq_dialise IS NOT NULL AND nr_seq_dialise::text <> '')
		and		nr_prescricao	= nr_prescricao_p;

		open c00 for
		SELECT	nr_sequencia
		from    hd_prescricao
		where   nr_prescricao	=  nr_prescricao_p;
	end if;

	loop
	fetch c00 into
		nr_sequencia_w;
	EXIT WHEN NOT FOUND; /* apply on c00 */

		select	count(*)
		into STRICT	ie_erro_w
		from	hd_prescricao a,
				prescr_solucao b
		where 	b.nr_seq_dialise		= a.nr_sequencia
		and		a.nr_prescricao			= b.nr_prescricao
		and		a.nr_prescricao			= nr_prescricao_p
		and		a.nr_sequencia			= nr_sequencia_w;

		if (coalesce(ie_erro_w,0) = 0) and (Wheb_assist_pck.Obter_se_consiste_rep(281,cd_perfil_p) = 'S') then
			ie_erro_liberar_prescr_w := obter_lib_erro_regra_rep(281, cd_perfil_p);
			nr_seq_erro_w := gerar_erro_prescr_dialise(nr_prescricao_p, nr_sequencia_w, 281, ie_erro_liberar_prescr_w, null, cd_perfil_p, nm_usuario_p, nr_seq_erro_w);
		end if;

		select	count(*)
		into STRICT	qt_erro_nao_lib_w
		from	prescr_medica_erro
		where	ie_libera		= 'N'
		and		nr_seq_dialise	= nr_sequencia_w
		and		nr_prescricao	= nr_prescricao_p  LIMIT 1;

		select	count(*)
		into STRICT	qt_erro_lib_w
		from	prescr_medica_erro
		where	ie_libera			= 'S'
		and		nr_seq_dialise		= nr_sequencia_w
		and		nr_prescricao		= nr_prescricao_p  LIMIT 1;

		if (qt_erro_nao_lib_w > 0) then

			update	hd_prescricao
			set		ie_erro		= 125,
					ds_cor_erro	= obter_cor_erro_prescr_rec(nr_prescricao_p, nr_sequencia_w, 125, cd_estabelecimento_p, cd_perfil_p)
			where	nr_sequencia	= nr_sequencia_w
			and		nr_prescricao	= nr_prescricao_p;

			ds_erro_p	:= '125';

		elsif (qt_erro_lib_w > 0) then

			update	hd_prescricao
			set		ie_erro		= 124,
					ds_cor_erro	= obter_cor_erro_prescr_rec(nr_prescricao_p, nr_sequencia_w, 124, cd_estabelecimento_p, cd_perfil_p)
			where	nr_sequencia	= nr_sequencia_w
			and		nr_prescricao	= nr_prescricao_p;
		else

			update	hd_prescricao
			set		ie_erro		= 0,
					ds_cor_erro	 = NULL
			where	nr_sequencia	= nr_sequencia_w
			and		nr_prescricao	= nr_prescricao_p;
		end if;
	end loop;
	close c00;

end if;

commit;

if (coalesce(nr_seq_dialise_p,0) > 0) then
	select	max(ie_erro)
	into STRICT	ds_erro_p
	from	hd_prescricao
	where	nr_sequencia	= nr_seq_dialise_p
	and		nr_prescricao	= nr_prescricao_p;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE consistir_prescr_dialise ( nr_prescricao_p bigint, nr_seq_dialise_p bigint, cd_estabelecimento_p bigint, cd_perfil_p bigint, nm_usuario_p text, ds_erro_p INOUT text) FROM PUBLIC;
