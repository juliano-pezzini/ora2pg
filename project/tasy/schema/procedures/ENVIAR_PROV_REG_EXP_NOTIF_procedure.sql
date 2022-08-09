-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE enviar_prov_reg_exp_notif (ds_sender_email_p text, sender_nm_usuario_p text) AS $body$
DECLARE


cd_pessoa_fisica_w      CRM_ESTADO.CD_PESSOA_FISICA%TYPE;
nm_usuario_w            CRM_ESTADO.NM_USUARIO%TYPE;
ds_usuario_w            USUARIO.DS_USUARIO%TYPE;
ds_email_w              USUARIO.DS_EMAIL%TYPE;
ds_titulo_w		        varchar(255);
ds_mensagem_w		    varchar(4000);

C01 CURSOR FOR
    SELECT cd_pessoa_fisica, nm_usuario
    FROM CRM_ESTADO 
    WHERE trunc(dt_fim_vigencia) = trunc(clock_timestamp());

C02 CURSOR FOR
    SELECT cd_pessoa_fisica, nm_usuario
    FROM PROFISSIONAL_SEGURO 
    WHERE trunc(dt_fim_vigencia) = trunc(clock_timestamp());


BEGIN
    ds_titulo_w := wheb_mensagem_pck.get_texto(1120380);
    OPEN C01;
    LOOP
        FETCH C01 INTO cd_pessoa_fisica_w, nm_usuario_w;
        EXIT WHEN NOT FOUND; /* apply on C01 */
        BEGIN
            select max(ds_usuario) into STRICT  ds_usuario_w from usuario where cd_pessoa_fisica = cd_pessoa_fisica_w;
            ds_mensagem_w := wheb_mensagem_pck.get_texto(1120375,'DS_USUARIO='||ds_usuario_w||';CD_PESSOA_FISICA='||cd_pessoa_fisica_w);

            select max(ds_email) into STRICT ds_email_w from usuario where nm_usuario = nm_usuario_w;

            IF (ds_email_w IS NOT NULL AND ds_email_w::text <> '') THEN
                CALL enviar_Email( to_char(clock_timestamp(),'DD-MON-YYYY')||': '||ds_titulo_w,ds_mensagem_w,ds_sender_email_p,ds_email_w,sender_nm_usuario_p,'A');
            END IF;
        EXCEPTION
            WHEN no_data_found THEN
                INSERT INTO log_tasy(DT_ATUALIZACAO, NM_USUARIO, CD_LOG, DS_LOG)
                    VALUES (clock_timestamp(),'Job',9999, 'Provincial Registration Expiry Notification failed due to invalid email-id of Responsible Person:'||nm_usuario_w);
            WHEN OTHERS THEN
                INSERT INTO log_tasy(DT_ATUALIZACAO, NM_USUARIO, CD_LOG, DS_LOG)
                    VALUES (clock_timestamp(),'Job',9999, 'Provincial Registration Expiry Notification for :'||cd_pessoa_fisica_w||' failed. Responsible Person:'||nm_usuario_w);
        END;
    END LOOP;
    CLOSE C01;

	ds_titulo_w := wheb_mensagem_pck.get_texto(1121213);
	OPEN C02;
    LOOP
        FETCH C02 INTO cd_pessoa_fisica_w, nm_usuario_w;
        EXIT WHEN NOT FOUND; /* apply on C02 */
        BEGIN
            select max(ds_usuario) into STRICT  ds_usuario_w from usuario where cd_pessoa_fisica = cd_pessoa_fisica_w;
            ds_mensagem_w := wheb_mensagem_pck.get_texto(1121214,'DS_USUARIO='||ds_usuario_w||';CD_PESSOA_FISICA='||cd_pessoa_fisica_w);

            select max(ds_email) into STRICT ds_email_w from usuario where nm_usuario = nm_usuario_w;

            IF (ds_email_w IS NOT NULL AND ds_email_w::text <> '') THEN
                CALL enviar_Email( to_char(clock_timestamp(),'DD-MON-YYYY')||': '||ds_titulo_w,ds_mensagem_w,ds_sender_email_p,ds_email_w,sender_nm_usuario_p,'A');
            END IF;
        EXCEPTION
            WHEN no_data_found THEN
                INSERT INTO log_tasy(DT_ATUALIZACAO, NM_USUARIO, CD_LOG, DS_LOG)
                    VALUES (clock_timestamp(),'Job',9999, 'Physician Insurance Expiry Notification failed due to invalid email-id of Responsible Person:'||nm_usuario_w);
            WHEN OTHERS THEN
                INSERT INTO log_tasy(DT_ATUALIZACAO, NM_USUARIO, CD_LOG, DS_LOG)
                    VALUES (clock_timestamp(),'Job',9999, 'Physician Insurance Expiry  Notification for :'||cd_pessoa_fisica_w||' failed. Responsible Person:'||nm_usuario_w);
        END;
    END LOOP;
    CLOSE C02;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE enviar_prov_reg_exp_notif (ds_sender_email_p text, sender_nm_usuario_p text) FROM PUBLIC;
