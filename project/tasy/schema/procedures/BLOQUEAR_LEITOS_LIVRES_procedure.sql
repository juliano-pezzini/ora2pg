-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE bloquear_leitos_livres (cd_setor_atendimento_p bigint, cd_unidade_basica_p text, nm_paciente_p text, nr_atendimento_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint, ie_acao_p text default null, ie_chamador_p text default null) AS $body$
DECLARE


/*  ie_acao_p 
    D - Desbloquear - Unlocked
    B = Bloquear    - Locked
*/


/*  ie_chamador_p 
    T - Tela de Movimentação de Pacientes - Patient Movement Screen
    B = Tela do Panorama Clínico          - Clinical Panorama Screen
*/
C01 CURSOR(p_cd_setor_atendimento unidade_atendimento.cd_setor_atendimento%type
          ,p_cd_unidade_basica unidade_atendimento.cd_unidade_basica%type) FOR
	SELECT	cd_setor_atendimento,
		cd_unidade_basica,
		cd_unidade_compl,
		nr_seq_interno
	from UNIDADE_ATENDIMENTO
	where	cd_setor_atendimento = p_cd_setor_atendimento
	and	cd_unidade_basica = p_cd_unidade_basica
	and	coalesce(ie_situacao, 'A') = 'A'
	and	ie_acao_p = 'B'
	and	ie_status_unidade = 'L';

C02 CURSOR FOR
	SELECT	cd_setor_atendimento,
		cd_unidade_basica,
		cd_unidade_compl,
		nr_seq_interno
	from 	UNIDADE_ATENDIMENTO
	where	cd_setor_atendimento = cd_setor_atendimento_p
	and	cd_unidade_basica = cd_unidade_basica_p
	and	coalesce(ie_situacao, 'A') = 'A'
	and	ie_status_unidade = 'I'
	and	coalesce(ie_bloqueio_transf,'N') = 'S'
	and	ie_acao_p = 'D';

cd_setor_atendimento_w  unidade_atendimento.cd_setor_atendimento%type;
cd_unidade_basica_w	    unidade_atendimento.cd_unidade_basica%type;
cd_unidade_compl_w	    unidade_atendimento.cd_unidade_compl%type;	
nr_seq_interno_w	    unidade_atendimento.nr_seq_interno%type;
cd_setor_atendimento_ww	unidade_atendimento.cd_setor_atendimento%type;
cd_unidade_basica_ww	unidade_atendimento.cd_unidade_basica%type;


BEGIN

cd_setor_atendimento_ww := cd_setor_atendimento_p;
cd_unidade_basica_ww    := cd_unidade_basica_p;

if (ie_chamador_p = 'T') then
    select b.cd_setor_atendimento
          ,b.cd_unidade_basica
    into STRICT   cd_setor_atendimento_ww
          ,cd_unidade_basica_ww
    from   unidade_atendimento b
          ,atend_paciente_unidade a
    where  b.nr_seq_interno = a.nr_seq_unid_ant
      and  a.nr_seq_interno = obter_atepacu_paciente(nr_atendimento_p, 'A');
end if;

open C01(cd_setor_atendimento_ww
        ,cd_unidade_basica_ww);
loop
fetch C01 into
	cd_setor_atendimento_w,
	cd_unidade_basica_w,
	cd_unidade_compl_w,
	nr_seq_interno_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	CALL GERAR_OBS_LEITO_INTERDITADO(cd_setor_atendimento_w,
			cd_unidade_basica_w,
			cd_unidade_compl_w,
			REPLACE(obter_desc_expressao(880042), '#@DS_ATENDIMENTO#@', nr_atendimento_p || ' (' || nm_paciente_p || ')'),
			null,
			'I',
			0,
			nm_usuario_p);

	CALL panorama_leito_pck.ATUALIZAR_W_PAN_LEITO(cd_estabelecimento_p,nr_seq_interno_w,nm_usuario_p);

end loop;
close C01;

open C02;
loop
fetch C02 into
	cd_setor_atendimento_w,
	cd_unidade_basica_w,
	cd_unidade_compl_w,
	nr_seq_interno_w;
EXIT WHEN NOT FOUND; /* apply on C02 */
	CALL GERAR_OBS_LEITO_INTERDITADO(cd_setor_atendimento_w,
			cd_unidade_basica_w,
			cd_unidade_compl_w,
			null,
			null,
			'L',
			null,
			nm_usuario_p);

	CALL panorama_leito_pck.ATUALIZAR_W_PAN_LEITO(cd_estabelecimento_p,nr_seq_interno_w,nm_usuario_p);
end loop;
close C02;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE bloquear_leitos_livres (cd_setor_atendimento_p bigint, cd_unidade_basica_p text, nm_paciente_p text, nr_atendimento_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint, ie_acao_p text default null, ie_chamador_p text default null) FROM PUBLIC;
