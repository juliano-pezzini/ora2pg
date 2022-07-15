-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_cobranca_hemodialise ( ie_tipo_hemodialise_p text, nr_prescricao_p bigint, nm_usuario_p text) AS $body$
DECLARE

count_w		bigint;

cd_procedimento_w	bigint;
ie_origem_proced_w	bigint;
qt_procedimento_w	double precision;
cd_setor_atendimento_w	bigint;
cd_convenio_w		convenio.cd_convenio%type;
nr_seq_proc_interno_w	regra_cobranca_hd.nr_seq_proc_interno%type;
cd_estabelecimento_w	estabelecimento.cd_estabelecimento%type;
cd_categoria_w			atend_categoria_convenio.cd_categoria%type;

c01 CURSOR FOR
SELECT	max(cd_procedimento),
	max(ie_origem_proced),
	max(qt_procedimento),
	max(nr_seq_proc_interno)
from	regra_cobranca_hd
where	ie_tipo_hemodialise = ie_tipo_hemodialise_p
and		coalesce(cd_convenio,cd_convenio_w) = cd_convenio_w;


BEGIN

select	count(*)
into STRICT	count_w
from	regra_cobranca_hd
where	ie_tipo_hemodialise = ie_tipo_hemodialise_p;

select	max(cd_setor_atendimento),
		max(Obter_Convenio_Atendimento(nr_atendimento)),
		max(obter_estab_atendimento(nr_atendimento)),
		max(obter_dados_categ_conv(nr_atendimento,'CA'))
into STRICT	cd_setor_atendimento_w,
		cd_convenio_w,
		cd_estabelecimento_w,
		cd_categoria_w
from	prescr_medica
where	nr_prescricao = nr_prescricao_p;

if (count_w > 0) then

	open C01;
	loop
	fetch C01 into
		cd_procedimento_w,
		ie_origem_proced_w,
		qt_procedimento_w,
		nr_seq_proc_interno_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin
		if (nr_seq_proc_interno_w IS NOT NULL AND nr_seq_proc_interno_w::text <> '') and (coalesce(cd_procedimento_w::text, '') = '') then

			SELECT * FROM obter_proc_tab_interno_conv(nr_seq_proc_interno_w, cd_estabelecimento_w, cd_convenio_w, cd_categoria_w, null, cd_setor_atendimento_w, cd_procedimento_w, ie_origem_proced_w, null, clock_timestamp(), null, null, null, null, null, null, null, null) INTO STRICT cd_procedimento_w, ie_origem_proced_w;

		end if;


		CALL gerar_proc_pac_item_prescr(nr_prescricao_p, null,null,null,nr_seq_proc_interno_w, cd_procedimento_w, ie_origem_proced_w, qt_procedimento_w, cd_setor_atendimento_w,1, clock_timestamp(), nm_usuario_p, null, null, null,null);

		end;
	end loop;
	close C01;

end if;

if (coalesce(wheb_usuario_pck.get_ie_commit, 'S') = 'S') then commit; end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_cobranca_hemodialise ( ie_tipo_hemodialise_p text, nr_prescricao_p bigint, nm_usuario_p text) FROM PUBLIC;

