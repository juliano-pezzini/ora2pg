-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION images_ophthalmology_pck.get_data ( nr_seq_consulta_p bigint, nr_seq_consulta_form_p bigint) RETURNS SETOF T_OBJETO_ROW_DATA AS $body$
DECLARE

							
t_objeto_row_w					t_objeto_row;

cd_estabelecimento_w			estabelecimento.cd_estabelecimento%type	:= wheb_usuario_pck.get_cd_estabelecimento;
cd_perfil_w						perfil.cd_perfil%type							:= wheb_usuario_pck.get_cd_perfil;
nm_usuario_w					usuario.nm_usuario%type 						:= wheb_usuario_pck.get_nm_usuario;


exams CURSOR FOR
	SELECT 	nr_sequencia nr_sequencia,
				SUBSTR(obter_valor_dominio(8913,'AN'),1,100) DS_EXAME,
				897363 nr_seq_dic_objeto,
				obter_se_obj_schem_param(null,3010,cd_estabelecimento_w,cd_perfil_w,nm_usuario_w,967505,'S') ie_image_visible,
				obter_se_obj_schem_param(null,3010,cd_estabelecimento_w,cd_perfil_w,nm_usuario_w,967506,'S') ie_photo_visible,
				54190 nr_seq_ativacao,
				54190 nr_seq_ativacao_pac,
				dt_liberacao,
				'NR_SEQ_ANGIO_RETINO' key_name
	FROM   	oft_angio_retino
	WHERE  	nr_seq_consulta_form = nr_seq_consulta_form_p
	AND	   nr_seq_consulta		= nr_seq_consulta_p 
   and      coalesce(ie_tipo_registro,'A') = 'A'
	AND ((dt_liberacao IS NOT NULL AND dt_liberacao::text <> '') or nm_usuario = nm_usuario_w)
	
UNION

   SELECT 	nr_sequencia nr_sequencia,
				SUBSTR(obter_valor_dominio(8913,'RE'),1,100) DS_EXAME,
				897363 nr_seq_dic_objeto,
				obter_se_obj_schem_param(null,3010,cd_estabelecimento_w,cd_perfil_w,nm_usuario_w,1108033,'S') ie_image_visible,
				obter_se_obj_schem_param(null,3010,cd_estabelecimento_w,cd_perfil_w,nm_usuario_w,1108037,'S') ie_photo_visible,
				54190 nr_seq_ativacao,
				54190 nr_seq_ativacao_pac,
				dt_liberacao,
				'NR_SEQ_ANGIO_RETINO' key_name
	FROM   	oft_angio_retino 
	WHERE  	nr_seq_consulta_form = nr_seq_consulta_form_p
	AND	   nr_seq_consulta		= nr_seq_consulta_p 
   and      coalesce(ie_tipo_registro,'A') = 'R'
	AND ((dt_liberacao IS NOT NULL AND dt_liberacao::text <> '') or nm_usuario = nm_usuario_w)
	
UNION

	SELECT 	nr_sequencia,
				SUBSTR(obter_valor_dominio(8913,'BI'),1,100) DS_EXAME,
				900776 nr_seq_dic_objeto,
				obter_se_obj_schem_param(null,3010,cd_estabelecimento_w,cd_perfil_w,nm_usuario_w,971068,'S') ie_image_visible,
				obter_se_obj_schem_param(null,3010,cd_estabelecimento_w,cd_perfil_w,nm_usuario_w,971069,'S') ie_photo_visible,
				54189 nr_seq_ativacao,
				64768 nr_seq_ativacao_pac,
				dt_liberacao,
				'NR_SEQ_BIOMICROSCOPIA' key_name
	FROM   	OFT_BIOMICROSCOPIA 
	WHERE  	nr_seq_consulta_form = nr_seq_consulta_form_p
	AND	   nr_seq_consulta		= nr_seq_consulta_p 
	AND ((dt_liberacao IS NOT NULL AND dt_liberacao::text <> '') or nm_usuario = nm_usuario_w)
	
UNION

	SELECT 	nr_sequencia,
				SUBSTR(obter_valor_dominio(8913,'CA'),1,100) DS_EXAME,
				864995 nr_seq_dic_objeto,
				'S' ie_image_visible,
				'N' ie_photo_visible,
				null nr_seq_ativacao,
				null nr_seq_ativacao_pac,
				dt_liberacao,
				null key_name
	FROM   	OFT_CAPSULOTOMIA 
	WHERE  	nr_seq_consulta_form = nr_seq_consulta_form_p
	AND	   nr_seq_consulta		= nr_seq_consulta_p 
	AND ((dt_liberacao IS NOT NULL AND dt_liberacao::text <> '') or nm_usuario = nm_usuario_w)
	
UNION

	SELECT 	nr_sequencia,
				SUBSTR(obter_valor_dominio(8913,'DA'),1,100) DS_EXAME,
				901107 nr_seq_dic_objeto,
				'S' ie_image_visible,
				'N' ie_photo_visible,
				null nr_seq_ativacao,
				null nr_seq_ativacao_pac,
				dt_liberacao,
				null key_name
	FROM   	OFT_DALTONISMO
	WHERE  	nr_seq_consulta_form = nr_seq_consulta_form_p
	AND	   nr_seq_consulta		= nr_seq_consulta_p 
	AND ((dt_liberacao IS NOT NULL AND dt_liberacao::text <> '') or nm_usuario = nm_usuario_w)
	
UNION

	SELECT 	nr_sequencia,
				SUBSTR(obter_valor_dominio(8913,'EX'),1,100) DS_EXAME,
				868653 nr_seq_dic_objeto,
				obter_se_obj_schem_param(null,3010,cd_estabelecimento_w,cd_perfil_w,nm_usuario_w,941870,'S') ie_image_visible,
				obter_se_obj_schem_param(null,3010,cd_estabelecimento_w,cd_perfil_w,nm_usuario_w,941871,'S') ie_photo_visible,
				64769 nr_seq_ativacao,
				64770 nr_seq_ativacao_pac,
				dt_liberacao,
				'NR_SEQ_OFT_EXAME_EXTERNO' key_name
	FROM   	OFT_EXAME_EXTERNO 
	WHERE  	nr_seq_consulta_form = nr_seq_consulta_form_p
	AND	   nr_seq_consulta		= nr_seq_consulta_p 
	AND ((dt_liberacao IS NOT NULL AND dt_liberacao::text <> '') or nm_usuario = nm_usuario_w)
	
UNION

	SELECT 	nr_sequencia,
				SUBSTR(obter_valor_dominio(8913,'FO'),1,100) DS_EXAME,
				901414 nr_seq_dic_objeto,
				'S' ie_image_visible,
				'N' ie_photo_visible,
				null nr_seq_ativacao,
				null nr_seq_ativacao_pac,
				dt_liberacao,
				null key_name
	FROM   	OFT_FOTOCOAGULACAO_LASER 
	WHERE  	nr_seq_consulta_form = nr_seq_consulta_form_p 
	AND	   nr_seq_consulta		= nr_seq_consulta_p
	AND ((dt_liberacao IS NOT NULL AND dt_liberacao::text <> '') or nm_usuario = nm_usuario_w)
	
UNION

	SELECT 	nr_sequencia,
				SUBSTR(obter_valor_dominio(8913,'FU'),1,100) DS_EXAME,
				901438 nr_seq_dic_objeto,
				obter_se_obj_schem_param(null,3010,cd_estabelecimento_w,cd_perfil_w,nm_usuario_w,971927,'S') ie_image_visible,
				obter_se_obj_schem_param(null,3010,cd_estabelecimento_w,cd_perfil_w,nm_usuario_w,971928,'S') ie_photo_visible,
				64771 nr_seq_ativacao,
				64772 nr_seq_ativacao_pac,
				dt_liberacao,
				'NR_SEQ_FUNDOSCOPIA' key_name
	FROM   	oft_fundoscopia
	WHERE  	nr_seq_consulta_form = nr_seq_consulta_form_p
	AND	   nr_seq_consulta		= nr_seq_consulta_p 
	AND ((dt_liberacao IS NOT NULL AND dt_liberacao::text <> '') or nm_usuario = nm_usuario_w)
	
UNION

	SELECT 	nr_sequencia,
							SUBSTR(obter_valor_dominio(8913,'AB'),1,100) DS_EXAME,
				1093447 nr_seq_dic_objeto,
				obter_se_obj_schem_param(null,3010,cd_estabelecimento_w,cd_perfil_w,nm_usuario_w,1131172,'S') ie_image_visible,
				obter_se_obj_schem_param(null,3010,cd_estabelecimento_w,cd_perfil_w,nm_usuario_w,1131176,'S') ie_photo_visible,
				66505 nr_seq_ativacao,
				66506 nr_seq_ativacao_pac,
				dt_liberacao,
				'NR_SEQ_ABERROMETRIA' key_name
	FROM   	oft_aberrometria
	WHERE  	nr_seq_consulta_form = nr_seq_consulta_form_p
	AND	   nr_seq_consulta		= nr_seq_consulta_p 
	AND ((dt_liberacao IS NOT NULL AND dt_liberacao::text <> '') or nm_usuario = nm_usuario_w)
	
UNION

	SELECT 	nr_sequencia,
				SUBSTR(obter_valor_dominio(8913,'GO'),1,100) DS_EXAME,
				954719 nr_seq_dic_objeto,
				'S' ie_image_visible,
				'N' ie_photo_visible,
				null nr_seq_ativacao,
				null nr_seq_ativacao_pac,
				dt_liberacao,
				null key_name
	FROM   	oft_gonioscopia
	WHERE  	nr_seq_consulta_form = nr_seq_consulta_form_p
	AND	   nr_seq_consulta		= nr_seq_consulta_p 
	AND ((dt_liberacao IS NOT NULL AND dt_liberacao::text <> '') or nm_usuario = nm_usuario_w)
	
UNION

	SELECT 	nr_sequencia,
				SUBSTR(obter_valor_dominio(8913,'IR'),1,100) DS_EXAME,
				954724 nr_seq_dic_objeto,
				'S' ie_image_visible,
				'N' ie_photo_visible,
				null nr_seq_ativacao,
				null nr_seq_ativacao_pac,
				dt_liberacao,
				null key_name
	FROM   	oft_iridectomia 
	WHERE  	nr_seq_consulta_form = nr_seq_consulta_form_p
	AND	   nr_seq_consulta		= nr_seq_consulta_p 
	AND ((dt_liberacao IS NOT NULL AND dt_liberacao::text <> '') or nm_usuario = nm_usuario_w)
	
UNION

	SELECT 	nr_sequencia,
				SUBSTR(obter_valor_dominio(8913,'MA'),1,100) DS_EXAME,
				901768 nr_seq_dic_objeto,
				obter_se_obj_schem_param(null,3010,cd_estabelecimento_w,cd_perfil_w,nm_usuario_w,972659,'S') ie_image_visible,
				obter_se_obj_schem_param(null,3010,cd_estabelecimento_w,cd_perfil_w,nm_usuario_w,972660,'S') ie_photo_visible,
				64773 nr_seq_ativacao,
				64774 nr_seq_ativacao_pac,
				dt_liberacao,
				'NR_SEQ_MAPEAMENTO' key_name
	FROM   	OFT_MAPEAMENTO_RETINA 
	WHERE  	nr_seq_consulta_form = nr_seq_consulta_form_p
	AND	   nr_seq_consulta		= nr_seq_consulta_p 
	AND ((dt_liberacao IS NOT NULL AND dt_liberacao::text <> '') or nm_usuario = nm_usuario_w)
	
UNION

	SELECT 	nr_sequencia,
				SUBSTR(obter_valor_dominio(8913,'TM'),1,100) DS_EXAME,
				null nr_seq_dic_objeto,
				'N' ie_image_visible,
				'S' ie_photo_visible,
				64775 nr_seq_ativacao,
				64776 nr_seq_ativacao_pac,
				dt_liberacao,
				'NR_SEQ_TOMOGRAFIA' key_name
	FROM   	OFT_TOMOGRAFIA_OLHO 
	WHERE  	nr_seq_consulta_form = nr_seq_consulta_form_p
	AND	   nr_seq_consulta		= nr_seq_consulta_p 
	AND ((dt_liberacao IS NOT NULL AND dt_liberacao::text <> '') or nm_usuario = nm_usuario_w)
	
UNION

	SELECT 	nr_sequencia,
				SUBSTR(obter_valor_dominio(8913,'UL'),1,100) DS_EXAME,
				932850 nr_seq_dic_objeto,
				obter_se_obj_schem_param(null,3010,cd_estabelecimento_w,cd_perfil_w,nm_usuario_w,981870,'S') ie_image_visible,
				obter_se_obj_schem_param(null,3010,cd_estabelecimento_w,cd_perfil_w,nm_usuario_w,981871,'S') ie_photo_visible,
				64779 NR_SEQ_ATIVACAO,
				64780 nr_seq_ativacao_pac,
				dt_liberacao,
				'NR_SEQ_ULTRASSONOGRAFIA' key_name
	FROM   	OFT_ULTRASSONOGRAFIA 
	WHERE  	nr_seq_consulta_form = nr_seq_consulta_form_p 
	AND	   nr_seq_consulta		= nr_seq_consulta_p
	AND ((dt_liberacao IS NOT NULL AND dt_liberacao::text <> '') or nm_usuario = nm_usuario_w)
	
UNION

	SELECT 	nr_sequencia,
				SUBSTR(obter_valor_dominio(8913,'ME'),1,100) DS_EXAME,
				null nr_seq_dic_objeto,
				'N' ie_image_visible,
				'S' ie_photo_visible,
				64781 nr_seq_ativacao,
				64782 nr_seq_ativacao_pac,
				dt_liberacao,
				'NR_SEQ_MICROSCOPIA' key_name
	FROM   	OFT_MICROSCOPIA_ESPECULAR 
	WHERE  	nr_seq_consulta_form = nr_seq_consulta_form_p 
	AND	   nr_seq_consulta		= nr_seq_consulta_p
	AND ((dt_liberacao IS NOT NULL AND dt_liberacao::text <> '') or nm_usuario = nm_usuario_w)
	
UNION

	SELECT 	nr_sequencia,
				SUBSTR(obter_valor_dominio(8913,'TO'),1,100) DS_EXAME,
				878948 nr_seq_dic_objeto,
				obter_se_obj_schem_param(null,3010,cd_estabelecimento_w,cd_perfil_w,nm_usuario_w,954309,'S') ie_image_visible,
				obter_se_obj_schem_param(null,3010,cd_estabelecimento_w,cd_perfil_w,nm_usuario_w,954310,'S') ie_photo_visible,
				64783 nr_seq_ativacao,
				64784 nr_seq_ativacao_pac,
				dt_liberacao,
				'NR_SEQ_OCT' key_name
	FROM   	OFT_OCT 
	WHERE  	nr_seq_consulta_form = nr_seq_consulta_form_p 
	AND	   nr_seq_consulta		= nr_seq_consulta_p
	AND ((dt_liberacao IS NOT NULL AND dt_liberacao::text <> '') or nm_usuario = nm_usuario_w)
	
UNION

	SELECT 	nr_sequencia,
				SUBSTR(obter_valor_dominio(8913,'CM'),1,100) DS_EXAME,
				null nr_seq_dic_objeto,
				'N' ie_image_visible,
				'S' ie_photo_visible,
				64785 nr_seq_ativacao,
				64786 nr_seq_ativacao_pac,
				dt_liberacao,
				'NR_SEQ_CAMPIMETRIA' key_name
	FROM   	OFT_CAMPIMETRIA 
	WHERE  	nr_seq_consulta_form = nr_seq_consulta_form_p 
	AND	   nr_seq_consulta		= nr_seq_consulta_p
	AND ((dt_liberacao IS NOT NULL AND dt_liberacao::text <> '') or nm_usuario = nm_usuario_w)
	
UNION

	SELECT 	nr_sequencia,
				SUBSTR(obter_valor_dominio(8913,'BM'),1,100) DS_EXAME,
				null nr_seq_dic_objeto,
				'N' ie_image_visible,
				'S' ie_photo_visible,
				64787 nr_seq_ativacao,
				64788 nr_seq_ativacao_pac,
				dt_liberacao,
				'NR_SEQ_BIOMETRIA' key_name
	FROM   	OFT_BIOMETRIA 
	WHERE  	nr_seq_consulta_form = nr_seq_consulta_form_p 
	AND	   nr_seq_consulta		= nr_seq_consulta_p
	AND ((dt_liberacao IS NOT NULL AND dt_liberacao::text <> '') or nm_usuario = nm_usuario_w)
	
UNION

	SELECT 	nr_sequencia,
				SUBSTR(obter_valor_dominio(8913,'PA'),1,100) DS_EXAME,
				null nr_seq_dic_objeto,
				'N' ie_image_visible,
				'S' ie_photo_visible,
				54191 nr_seq_ativacao,
				64789 nr_seq_ativacao_pac,
				dt_liberacao,
				'NR_SEQ_PAQUIMETRIA' key_name
	FROM   	OFT_PAQUIMETRIA 
	WHERE  	nr_seq_consulta_form = nr_seq_consulta_form_p 
	AND	   nr_seq_consulta		= nr_seq_consulta_p
	AND ((dt_liberacao IS NOT NULL AND dt_liberacao::text <> '') or nm_usuario = nm_usuario_w)
	
UNION

	SELECT 	nr_sequencia,
				SUBSTR(obter_valor_dominio(8913,'CE'),1,100) DS_EXAME,
				null nr_seq_dic_objeto,
				'N' ie_image_visible,
				'S' ie_photo_visible,
				64791 nr_seq_ativacao,
				64792 nr_seq_ativacao_pac,
				dt_liberacao,
				'NR_SEQ_CERASTOCOPIA' key_name
	FROM   	OFT_CERASTOCOPIA 
	WHERE  	nr_seq_consulta_form = nr_seq_consulta_form_p 
	AND	   nr_seq_consulta		= nr_seq_consulta_p
	AND ((dt_liberacao IS NOT NULL AND dt_liberacao::text <> '') or nm_usuario = nm_usuario_w)
	ORDER BY 2;

BEGIN
FOR c_exams IN exams LOOP
	BEGIN
	t_objeto_row_w.nr_sequencia			:= c_exams.nr_sequencia;
	t_objeto_row_w.ds_exame				:= c_exams.ds_exame;
	t_objeto_row_w.nr_seq_dic_objeto	:= c_exams.nr_seq_dic_objeto;
	t_objeto_row_w.ie_image_visible		:= c_exams.ie_image_visible;
	t_objeto_row_w.ie_photo_visible		:= c_exams.ie_photo_visible;
	t_objeto_row_w.nr_seq_ativacao		:= c_exams.nr_seq_ativacao;
	t_objeto_row_w.nr_seq_ativacao_pac	:= c_exams.nr_seq_ativacao_pac;
	t_objeto_row_w.dt_liberacao			:= c_exams.dt_liberacao;
	t_objeto_row_w.key_name				:= c_exams.key_name;
	RETURN NEXT t_objeto_row_w;
	END;
end loop;	

RETURN;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION images_ophthalmology_pck.get_data ( nr_seq_consulta_p bigint, nr_seq_consulta_form_p bigint) FROM PUBLIC;